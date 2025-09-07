#!/usr/bin/env python3
"""
Numpad MIDI Controller using virmidi rawmidi device
Maps numpad 1-9 to scale degrees, +/- for root note, */÷ for octave, Enter for major/minor
"""

import rtmidi
import asyncio
import logging
import subprocess
import signal
import sys
from evdev import InputDevice, categorize, ecodes, list_devices

from murtaza.log import setup_logging

class NumpadMidiVirmidi:
    def __init__(self):
        self.logger = logging.getLogger(__name__)
        self.midi_out = rtmidi.MidiOut()
        self.notification_id = None  # Track notification ID for replacement
        self.running = True  # Flag for graceful shutdown
        
        # List available MIDI ports
        available_ports = self.midi_out.get_ports()
        self.logger.debug(f"Available MIDI ports: {available_ports}")
        
        # Find a VirMIDI port
        virmidi_port = None
        for i, port_name in enumerate(available_ports):
            if "VirMIDI" in port_name:
                virmidi_port = i
                self.logger.info(f"Using VirMIDI port: {port_name}")
                break
        
        if virmidi_port is not None:
            self.midi_out.open_port(virmidi_port)
        else:
            self.logger.warning("No VirMIDI port found, creating virtual port")
            self.midi_out.open_virtual_port("Numpad MIDI")
        
        # Scale and music theory setup
        self.root_note = 60  # Middle C (C4)
        self.octave_offset = 0
        self.is_major = True
        
        # Scale intervals (semitones from root)
        self.major_scale = [0, 2, 4, 5, 7, 9, 11, 12, 14]  # 1-9 scale degrees
        self.minor_scale = [0, 2, 3, 5, 7, 8, 10, 12, 14]  # Natural minor
        
        # Numpad key mapping to scale degrees
        self.scale_keys = {
            ecodes.KEY_KP1: 0,  # 1st degree
            ecodes.KEY_KP2: 1,  # 2nd degree  
            ecodes.KEY_KP3: 2,  # 3rd degree
            ecodes.KEY_KP4: 3,  # 4th degree
            ecodes.KEY_KP5: 4,  # 5th degree
            ecodes.KEY_KP6: 5,  # 6th degree
            ecodes.KEY_KP7: 6,  # 7th degree
            ecodes.KEY_KP8: 7,  # Octave (8th)
            ecodes.KEY_KP9: 8,  # 9th degree
        }
        
        # Control keys
        self.control_keys = {
            ecodes.KEY_KPPLUS,    # Root note up
            ecodes.KEY_KPMINUS,   # Root note down
            ecodes.KEY_KPASTERISK, # Octave up
            ecodes.KEY_KPSLASH,   # Octave down
            ecodes.KEY_KPENTER,   # Toggle major/minor
        }
        
        # Track pressed keys
        self.pressed_keys = set()
        
        # Find keyboard devices
        self.devices = []
        self.find_keyboard_devices()
        
        self.print_status()
        self.logger.info("Controls: Numpad 1-9=Scale degrees, +/-=Root note, */÷=Octave, Enter=Major/Minor")
        self.send_notification("🎹 Numpad MIDI Controller Ready", duration=2000)
        
        # Set up signal handlers for graceful shutdown
        signal.signal(signal.SIGTERM, self.signal_handler)
        signal.signal(signal.SIGINT, self.signal_handler)
    
    def find_keyboard_devices(self):
        """Find all keyboard input devices"""
        devices = [InputDevice(path) for path in list_devices()]
        for device in devices:
            caps = device.capabilities()
            if ecodes.EV_KEY in caps:
                keys = caps[ecodes.EV_KEY]
                if any(key in keys for key in [ecodes.KEY_KP1, ecodes.KEY_KP2, ecodes.KEY_KP3]):
                    self.logger.debug(f"Found keyboard: {device.name} ({device.path})")
                    self.devices.append(device)
        
        if not self.devices:
            self.logger.error("No keyboard devices found!")
    
    def signal_handler(self, signum, frame):
        """Handle shutdown signals gracefully"""
        self.logger.info(f"Received signal {signum}, shutting down gracefully...")
        self.running = False
        self.send_notification("🎹 Numpad MIDI Disabled", duration=1500)
        self.cleanup()
        sys.exit(0)
    
    def send_notification(self, message, duration=2000):
        """Send notify-send notification with replacement"""
        try:
            cmd = [
                'notify-send',
                '--app-name=Numpad MIDI',
                '--expire-time', str(duration),
                '--icon=audio-headphones',
                '--print-id'
            ]
            
            # If we have a previous notification ID, replace it
            if self.notification_id:
                cmd.extend(['--replace-id', str(self.notification_id)])
            
            cmd.append(message)
            
            # Run and capture the notification ID
            result = subprocess.run(cmd, check=False, capture_output=True, text=True)
            if result.returncode == 0 and result.stdout.strip().isdigit():
                self.notification_id = int(result.stdout.strip())
                
        except Exception as e:
            self.logger.debug(f"Failed to send notification: {e}")
    
    def print_status(self):
        """Print and notify current scale and root note status"""
        note_names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
        root_name = note_names[self.root_note % 12]
        octave = (self.root_note // 12) - 1 + self.octave_offset
        scale_type = "Major" if self.is_major else "Minor"
        status_msg = f"{root_name}{octave} {scale_type.lower()}"
        
        self.logger.info(f"Current: {status_msg}")
        self.send_notification(f"🎹 {status_msg}", duration=1500)
    
    def get_note_for_degree(self, degree):
        """Get MIDI note number for a scale degree"""
        scale = self.major_scale if self.is_major else self.minor_scale
        interval = scale[degree]
        return self.root_note + interval + (self.octave_offset * 12)
    
    def handle_control_key(self, key_code):
        """Handle control key presses (root note, octave, scale changes)"""
        if key_code == ecodes.KEY_KPPLUS:
            self.root_note = (self.root_note + 1) % 128
            self.print_status()
        elif key_code == ecodes.KEY_KPMINUS:
            self.root_note = (self.root_note - 1) % 128
            self.print_status()
        elif key_code == ecodes.KEY_KPASTERISK:
            self.octave_offset += 1
            self.print_status()
        elif key_code == ecodes.KEY_KPSLASH:
            self.octave_offset -= 1
            self.print_status()
        elif key_code == ecodes.KEY_KPENTER:
            self.is_major = not self.is_major
            self.print_status()
    
    def send_note_on(self, note, velocity=64):
        """Send MIDI note on message"""
        msg = [0x90, note, velocity]
        self.midi_out.send_message(msg)
        self.logger.debug(f"Note ON: {note} (vel: {velocity})")
    
    def send_note_off(self, note):
        """Send MIDI note off message"""
        msg = [0x80, note, 0]
        self.midi_out.send_message(msg)
        self.logger.debug(f"Note OFF: {note}")
    
    async def handle_device(self, device):
        """Handle events from a single device"""
        try:
            async for event in device.async_read_loop():
                if event.type == ecodes.EV_KEY:
                    # Handle control keys (only on key press)
                    if event.value == 1 and event.code in self.control_keys:
                        self.handle_control_key(event.code)
                    
                    # Handle scale degree keys (press/release for notes)
                    elif event.code in self.scale_keys:
                        degree = self.scale_keys[event.code]
                        note = self.get_note_for_degree(degree)
                        
                        if event.value == 1:  # Key press
                            if event.code not in self.pressed_keys:
                                self.send_note_on(note)
                                self.pressed_keys.add(event.code)
                        elif event.value == 0:  # Key release
                            if event.code in self.pressed_keys:
                                self.send_note_off(note)
                                self.pressed_keys.remove(event.code)
        except OSError as e:
            self.logger.warning(f"Device {device.path} disconnected: {e}")
    
    async def start_listening(self):
        """Start listening for keyboard events"""
        if not self.devices:
            self.logger.error("No devices to monitor!")
            return
        
        tasks = [asyncio.create_task(self.handle_device(device)) for device in self.devices]
        
        try:
            await asyncio.gather(*tasks)
        except KeyboardInterrupt:
            self.logger.info("Exiting...")
        finally:
            for task in tasks:
                task.cancel()
    
    def cleanup(self):
        """Cleanup resources"""
        self.midi_out.close_port()
        for device in self.devices:
            device.close()
        self.logger.info("MIDI port closed")

def main():
    import argparse
    parser = argparse.ArgumentParser(description='Numpad MIDI Controller')
    parser.add_argument('-d', '--debug', action='store_true', help='Enable debug logging')
    args = parser.parse_args()
    
    # Setup logging
    log_level = logging.DEBUG if args.debug else logging.INFO
    logger = setup_logging(log_level)
    
    logger.info("Numpad MIDI Controller starting...")
    
    try:
        midi_controller = NumpadMidiVirmidi()
        asyncio.run(midi_controller.start_listening())
    except KeyboardInterrupt:
        logger.info("Exiting...")
    except PermissionError:
        logger.error("Permission denied! You may need to:")
        logger.error("1. Run with sudo, or")
        logger.error("2. Add your user to the 'input' group: sudo usermod -a -G input $USER")
        logger.error("3. Then log out and log back in")
    finally:
        if 'midi_controller' in locals():
            midi_controller.cleanup()

if __name__ == "__main__":
    main()

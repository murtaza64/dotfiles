#!/usr/bin/env python3
"""
Numpad MIDI Controller with AppIndicator System Tray
"""

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('AppIndicator3', '0.1')

from gi.repository import Gtk, AppIndicator3, GLib
import threading
import asyncio
import logging
import signal
import sys

from numpad_midi_virmidi import NumpadMidiVirmidi
from murtaza.log import setup_logging

class MidiAppIndicator:
    def __init__(self, midi_controller):
        self.midi_controller = midi_controller
        self.logger = logging.getLogger(__name__)
        
        # Create AppIndicator
        self.indicator = AppIndicator3.Indicator.new(
            "numpad-midi-controller",
            "audio-headphones-symbolic",  # Icon name from system icons
            AppIndicator3.IndicatorCategory.APPLICATION_STATUS
        )
        self.indicator.set_status(AppIndicator3.IndicatorStatus.ACTIVE)
        self.indicator.set_title("Numpad MIDI")
        
        # Create menu
        self.create_menu()
        
        # Set initial status
        self.update_status()
        
        # Override the midi controller's print_status to update indicator
        original_print_status = self.midi_controller.print_status
        def enhanced_print_status():
            original_print_status()
            # Update indicator on main thread
            GLib.idle_add(self.update_status)
        
        self.midi_controller.print_status = enhanced_print_status
        
        self.logger.info("AppIndicator created successfully")
    
    def create_menu(self):
        """Create the context menu"""
        menu = Gtk.Menu()
        
        # Status item (non-clickable)
        self.status_item = Gtk.MenuItem(label="🎹 Numpad MIDI Active")
        self.status_item.set_sensitive(False)
        menu.append(self.status_item)
        
        # Separator
        separator = Gtk.SeparatorMenuItem()
        menu.append(separator)
        
        # Scale toggle
        major_item = Gtk.MenuItem(label="Switch to Major")
        major_item.connect("activate", self.on_major_clicked)
        menu.append(major_item)
        
        minor_item = Gtk.MenuItem(label="Switch to Minor")
        minor_item.connect("activate", self.on_minor_clicked) 
        menu.append(minor_item)
        
        # Separator
        separator2 = Gtk.SeparatorMenuItem()
        menu.append(separator2)
        
        # Root note controls
        root_up_item = Gtk.MenuItem(label="Root Note Up (+)")
        root_up_item.connect("activate", self.on_root_up)
        menu.append(root_up_item)
        
        root_down_item = Gtk.MenuItem(label="Root Note Down (-)")
        root_down_item.connect("activate", self.on_root_down)
        menu.append(root_down_item)
        
        # Octave controls
        octave_up_item = Gtk.MenuItem(label="Octave Up (*)")
        octave_up_item.connect("activate", self.on_octave_up)
        menu.append(octave_up_item)
        
        octave_down_item = Gtk.MenuItem(label="Octave Down (/)")
        octave_down_item.connect("activate", self.on_octave_down)
        menu.append(octave_down_item)
        
        # Separator
        separator3 = Gtk.SeparatorMenuItem()
        menu.append(separator3)
        
        # Quit
        quit_item = Gtk.MenuItem(label="Quit")
        quit_item.connect("activate", self.on_quit)
        menu.append(quit_item)
        
        menu.show_all()
        self.indicator.set_menu(menu)
    
    def update_status(self):
        """Update the status display in the menu"""
        note_names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
        root_name = note_names[self.midi_controller.root_note % 12]
        octave = (self.midi_controller.root_note // 12) - 1 + self.midi_controller.octave_offset
        scale_type = "Major" if self.midi_controller.is_major else "Minor"
        status = f"🎹 {root_name}{octave} {scale_type}"
        
        self.status_item.set_label(status)
        
        # Update tooltip/title if possible
        self.indicator.set_title(f"Numpad MIDI: {root_name}{octave} {scale_type}")
    
    def on_major_clicked(self, widget):
        """Switch to major scale"""
        if not self.midi_controller.is_major:
            self.midi_controller.is_major = True
            self.midi_controller.print_status()
    
    def on_minor_clicked(self, widget):
        """Switch to minor scale"""
        if self.midi_controller.is_major:
            self.midi_controller.is_major = False
            self.midi_controller.print_status()
    
    def on_root_up(self, widget):
        """Increase root note"""
        self.midi_controller.root_note = (self.midi_controller.root_note + 1) % 128
        self.midi_controller.print_status()
    
    def on_root_down(self, widget):
        """Decrease root note"""
        self.midi_controller.root_note = (self.midi_controller.root_note - 1) % 128
        self.midi_controller.print_status()
    
    def on_octave_up(self, widget):
        """Increase octave offset"""
        self.midi_controller.octave_offset += 1
        self.midi_controller.print_status()
    
    def on_octave_down(self, widget):
        """Decrease octave offset"""
        self.midi_controller.octave_offset -= 1
        self.midi_controller.print_status()
    
    def on_quit(self, widget):
        """Quit the application"""
        self.logger.info("Quit requested from tray menu")
        self.midi_controller.running = False
        self.midi_controller.cleanup()
        Gtk.main_quit()

def signal_handler(signum, frame):
    """Handle shutdown signals"""
    print(f"\nReceived signal {signum}, shutting down...")
    Gtk.main_quit()

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='Numpad MIDI Controller with AppIndicator')
    parser.add_argument('-d', '--debug', action='store_true', help='Enable debug logging')
    args = parser.parse_args()
    
    # Setup logging
    log_level = logging.DEBUG if args.debug else logging.INFO
    logger = setup_logging(log_level)
    
    logger.info("Numpad MIDI Controller with AppIndicator starting...")
    
    # Set up signal handlers
    signal.signal(signal.SIGTERM, signal_handler)
    signal.signal(signal.SIGINT, signal_handler)
    
    try:
        # Create MIDI controller
        midi_controller = NumpadMidiVirmidi()
        
        # Create AppIndicator
        app_indicator = MidiAppIndicator(midi_controller)
        
        # Run MIDI controller in separate thread
        def run_midi():
            try:
                asyncio.run(midi_controller.start_listening())
            except Exception as e:
                logger.error(f"MIDI controller error: {e}")
                # Signal main thread to quit
                GLib.idle_add(Gtk.main_quit)
        
        midi_thread = threading.Thread(target=run_midi, daemon=True)
        midi_thread.start()
        
        # Run GTK main loop
        Gtk.main()
        
    except KeyboardInterrupt:
        logger.info("Exiting...")
    except PermissionError:
        logger.error("Permission denied! You may need to:")
        logger.error("1. Run with sudo, or")
        logger.error("2. Add your user to the 'input' group: sudo usermod -a -G input $USER")
        logger.error("3. Then log out and log back in")
    except Exception as e:
        logger.error(f"Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        if 'midi_controller' in locals():
            midi_controller.cleanup()

if __name__ == "__main__":
    main()
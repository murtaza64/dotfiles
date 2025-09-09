#!/usr/bin/env python3

import json
import os
from pathlib import Path
from typing import Optional, Dict, Any

class PywalColors:
    """Class to hold pywal colors with convenient access methods"""
    
    def __init__(self, data: Dict[str, Any]):
        self.checksum = data['checksum']
        self.wallpaper = data['wallpaper']
        self.alpha = data['alpha']
        
        # Special colors (background, foreground, cursor)
        special = data['special']
        self.background = special['background']
        self.foreground = special['foreground']
        self.cursor = special['cursor']
        
        # Numbered colors (color0-color15)
        colors = data['colors']
        
        # Hardcoded color attributes for type safety
        self.color0 = colors['color0']
        self.color1 = colors['color1']
        self.color2 = colors['color2']
        self.color3 = colors['color3']
        self.color4 = colors['color4']
        self.color5 = colors['color5']
        self.color6 = colors['color6']
        self.color7 = colors['color7']
        self.color8 = colors['color8']
        self.color9 = colors['color9']
        self.color10 = colors['color10']
        self.color11 = colors['color11']
        self.color12 = colors['color12']
        self.color13 = colors['color13']
        self.color14 = colors['color14']
        self.color15 = colors['color15']
        
        # Also build the list for indexed access
        self.colors = [
            self.color0, self.color1, self.color2, self.color3,
            self.color4, self.color5, self.color6, self.color7,
            self.color8, self.color9, self.color10, self.color11,
            self.color12, self.color13, self.color14, self.color15
        ]
        
        # ANSI colors with semantic names
        ansi = data['ansi']
        self.black = ansi['black']
        self.red = ansi['red']
        self.green = ansi['green']
        self.yellow = ansi['yellow']
        self.blue = ansi['blue']
        self.magenta = ansi['magenta']
        self.cyan = ansi['cyan']
        self.white = ansi['white']
        
        # Bright variants
        self.bright_black = ansi['bright_black']
        self.bright_red = ansi['bright_red']
        self.bright_green = ansi['bright_green']
        self.bright_yellow = ansi['bright_yellow']
        self.bright_blue = ansi['bright_blue']
        self.bright_magenta = ansi['bright_magenta']
        self.bright_cyan = ansi['bright_cyan']
        self.bright_white = ansi['bright_white']
    
    def get_color(self, index: int) -> str:
        """Get color by index (0-15)"""
        if 0 <= index < len(self.colors):
            return self.colors[index]
        return '#000000'
    
    def __repr__(self):
        return f"PywalColors(wallpaper='{self.wallpaper}', checksum='{self.checksum}')"


def load_pywal_colors(cache_path: Optional[str] = None) -> Optional[PywalColors]:
    """
    Load pywal colors from cache file
    
    Args:
        cache_path: Optional path to colors.json file. 
                   Defaults to ~/.cache/wal/colors.json
    
    Returns:
        PywalColors object if successful, None if file doesn't exist or can't be parsed
    """
    if cache_path is None:
        cache_path = os.path.expanduser('~/.cache/wal/colors.json')
    
    cache_file = Path(cache_path)
    
    if not cache_file.exists():
        return None
    
    try:
        with open(cache_file, 'r') as f:
            data = json.load(f)
        return PywalColors(data)
    except (json.JSONDecodeError, IOError) as e:
        print(f"Error loading pywal colors: {e}")
        return None


def get_colors() -> Optional[PywalColors]:
    """Convenience function to get pywal colors with default path"""
    return load_pywal_colors()


if __name__ == "__main__":
    # Test the module
    colors = get_colors()
    if colors:
        print(f"Loaded pywal colors: {colors}")
        print(f"Background: {colors.background}")
        print(f"Foreground: {colors.foreground}")
        print(f"Red: {colors.red}")
        print(f"Blue: {colors.blue}")
        print(f"Color 1 (indexed): {colors.get_color(1)}")
        print(f"Color 1 (attribute): {colors.color1}")
        print(f"Colors list: {colors.colors}")
    else:
        print("Could not load pywal colors")

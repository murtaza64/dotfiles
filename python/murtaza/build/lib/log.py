"""
Colored logging utilities for console output.

Provides a ColoredFormatter class and setup_logging function for consistent
colored logging across projects.
"""

import logging
import sys
import os
from pathlib import Path


class ColoredFormatter(logging.Formatter):
    """Custom formatter with colored log levels for console output"""
    
    COLORS = {
        'DEBUG': '\033[36m[D]\033[0m',      # Cyan
        'INFO': '\033[32m[I]\033[0m',       # Green
        'WARNING': '\033[33m[W]\033[0m',    # Yellow
        'ERROR': '\033[31m[E]\033[0m',      # Red
        'CRITICAL': '\033[35m[C]\033[0m',   # Magenta
    }

    def format(self, record):
        """Format log record with colored level indicator"""
        level_color = self.COLORS.get(record.levelname, '[?]')
        record.levelname = level_color
        return super().format(record)


def setup_logging(level=logging.INFO, format_string='[%(asctime)s] %(levelname)s %(message)s', log_file=None):
    """
    Setup colored logging for console output, with automatic file logging when not in TTY.
    
    Args:
        level: Logging level (default: logging.INFO)
        format_string: Log format string (default: '[%(asctime)s] %(levelname)s %(message)s')
        log_file: Optional log file path. If None and not in TTY, creates ~/logs/<script_name>.log
        
    Returns:
        logger: Configured logger instance
        
    Example:
        logger = setup_logging(logging.DEBUG)
        logger.info("This will be green [I]")
        logger.debug("This will be cyan [D]")
        logger.warning("This will be yellow [W]")
        logger.error("This will be red [E]")
    """
    logger = logging.getLogger()
    logger.setLevel(level)
    
    # Remove existing handlers to avoid duplicates
    for handler in logger.handlers[:]:
        logger.removeHandler(handler)
    
    # Determine if we're in a TTY
    in_tty = sys.stdout.isatty()
    
    if in_tty:
        # Console output with colors
        handler = logging.StreamHandler(sys.stdout)
        formatter = ColoredFormatter(format_string)
        formatter.datefmt = '%Y-%m-%d %H:%M:%S'
        handler.setFormatter(formatter)
        logger.addHandler(handler)
    else:
        # File logging when not in TTY (e.g., launched from DE)
        if log_file is None:
            # Auto-generate log file name
            import inspect
            frame = inspect.currentframe()
            while frame:
                filename = frame.f_globals.get('__file__')
                if filename and not filename.endswith('/logging.py'):
                    script_name = Path(filename).stem
                    break
                frame = frame.f_back
            else:
                script_name = 'unknown'
            
            log_dir = Path.home() / 'logs'
            log_dir.mkdir(exist_ok=True)
            log_file = log_dir / f'{script_name}.log'
        
        # File handler without colors
        handler = logging.FileHandler(log_file, mode='a')
        plain_formatter = logging.Formatter(format_string)
        plain_formatter.datefmt = '%Y-%m-%d %H:%M:%S'
        handler.setFormatter(plain_formatter)
        logger.addHandler(handler)
        
        # Also log startup message with file location
        logger.info(f"Logging to file: {log_file}")
    
    return logger


def get_logger(name=None, level=logging.INFO):
    """
    Get a logger instance with colored formatting.
    
    Args:
        name: Logger name (default: calling module's __name__)
        level: Logging level (default: logging.INFO)
        
    Returns:
        logger: Logger instance
        
    Example:
        logger = get_logger(__name__)
        logger.info("Hello from my module!")
    """
    if name is None:
        # Get caller's module name
        import inspect
        frame = inspect.currentframe().f_back
        name = frame.f_globals.get('__name__', 'unknown')
    
    # Ensure root logger is setup with colored formatting
    if not logging.getLogger().handlers:
        setup_logging(level)
    
    return logging.getLogger(name)
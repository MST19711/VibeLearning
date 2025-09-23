#!/usr/bin/env python3
"""
Photo Watermark Tool - Add date watermarks to photos based on EXIF data
"""

import os
import sys
import argparse
from PIL import Image, ImageDraw, ImageFont, ExifTags
from datetime import datetime
import shutil


class PhotoWatermark:
    def __init__(self):
        self.supported_formats = {'.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.tif'}
        
    def get_date_from_exif(self, image_path):
        """Extract date from EXIF data"""
        try:
            with Image.open(image_path) as img:
                exif_data = img._getexif()
                if not exif_data:
                    return None
                
                # Look for DateTimeOriginal, DateTime, or DateTimeDigitized
                date_tags = {
                    36867: 'DateTimeOriginal',
                    306: 'DateTime', 
                    36868: 'DateTimeDigitized'
                }
                
                for tag_id, tag_name in date_tags.items():
                    if tag_id in exif_data:
                        date_str = exif_data[tag_id]
                        # EXIF date format: "YYYY:MM:DD HH:MM:SS"
                        try:
                            date_obj = datetime.strptime(date_str, "%Y:%m:%d %H:%M:%S")
                            return date_obj.strftime("%Y-%m-%d")  # Return YYYY-MM-DD format
                        except ValueError:
                            continue
                            
                return None
        except Exception as e:
            print(f"Error reading EXIF data from {image_path}: {e}")
            return None
    
    def get_font(self, size):
        """Get a font object, fallback to default if specified font not found"""
        try:
            # Try to use a system font
            if os.name == 'nt':  # Windows
                font_path = "C:\\Windows\\Fonts\\arial.ttf"
            else:  # macOS/Linux
                font_paths = [
                    "/System/Library/Fonts/Helvetica.ttc",
                    "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
                    "/usr/share/fonts/TTF/DejaVuSans.ttf"
                ]
                font_path = None
                for path in font_paths:
                    if os.path.exists(path):
                        font_path = path
                        break
                        
            if font_path and os.path.exists(font_path):
                return ImageFont.truetype(font_path, size)
            else:
                # Fallback to default font
                return ImageFont.load_default()
        except Exception:
            return ImageFont.load_default()
    
    def get_position(self, img_width, img_height, text_width, text_height, position):
        """Calculate text position based on user preference"""
        margin = 20
        
        positions = {
            'top-left': (margin, margin),
            'top-center': ((img_width - text_width) // 2, margin),
            'top-right': (img_width - text_width - margin, margin),
            'center': ((img_width - text_width) // 2, (img_height - text_height) // 2),
            'bottom-left': (margin, img_height - text_height - margin),
            'bottom-center': ((img_width - text_width) // 2, img_height - text_height - margin),
            'bottom-right': (img_width - text_width - margin, img_height - text_height - margin)
        }
        
        return positions.get(position, positions['bottom-right'])
    
    def add_watermark(self, image_path, output_path, font_size, color, position):
        """Add watermark to a single image"""
        try:
            # Get date from EXIF
            date_text = self.get_date_from_exif(image_path)
            if not date_text:
                print(f"No EXIF date found for {image_path}, skipping...")
                return False
            
            # Open and process image
            with Image.open(image_path) as img:
                img = img.convert('RGB')
                draw = ImageDraw.Draw(img)
                
                # Get font and calculate text size
                font = self.get_font(font_size)
                bbox = draw.textbbox((0, 0), date_text, font=font)
                text_width = bbox[2] - bbox[0]
                text_height = bbox[3] - bbox[1]
                
                # Calculate position
                img_width, img_height = img.size
                x, y = self.get_position(img_width, img_height, text_width, text_height, position)
                
                # Draw text with outline for better visibility
                # Draw outline (black border)
                outline_color = (0, 0, 0)
                for offset in [-1, 0, 1]:
                    for offset_y in [-1, 0, 1]:
                        if offset != 0 or offset_y != 0:
                            draw.text((x + offset, y + offset_y), date_text, font=font, fill=outline_color)
                
                # Draw main text
                draw.text((x, y), date_text, font=font, fill=color)
                
                # Save the watermarked image
                img.save(output_path, quality=95)
                print(f"Watermarked: {os.path.basename(image_path)} -> {os.path.basename(output_path)}")
                return True
                
        except Exception as e:
            print(f"Error processing {image_path}: {e}")
            return False
    
    def process_directory(self, input_dir, font_size, color, position):
        """Process all images in a directory"""
        # Create output directory
        output_dir = os.path.join(input_dir, os.path.basename(input_dir) + "_watermark")
        os.makedirs(output_dir, exist_ok=True)
        
        # Find all image files
        image_files = []
        for file in os.listdir(input_dir):
            if any(file.lower().endswith(ext) for ext in self.supported_formats):
                image_files.append(file)
        
        if not image_files:
            print(f"No supported image files found in {input_dir}")
            return
        
        print(f"Found {len(image_files)} images to process")
        
        # Process each image
        processed = 0
        for image_file in image_files:
            input_path = os.path.join(input_dir, image_file)
            output_path = os.path.join(output_dir, image_file)
            
            if self.add_watermark(input_path, output_path, font_size, color, position):
                processed += 1
        
        print(f"\nProcessing complete: {processed}/{len(image_files)} images watermarked")
        print(f"Output directory: {output_dir}")


def parse_color(color_str):
    """Parse color string to RGB tuple"""
    if color_str.startswith('#'):
        # Hex color
        color_str = color_str[1:]
        if len(color_str) == 6:
            return tuple(int(color_str[i:i+2], 16) for i in (0, 2, 4))
    elif color_str.startswith('rgb(') and color_str.endswith(')'):
        # RGB color
        values = color_str[4:-1].split(',')
        return tuple(int(v.strip()) for v in values)
    
    # Default colors
    color_map = {
        'white': (255, 255, 255),
        'black': (0, 0, 0),
        'red': (255, 0, 0),
        'green': (0, 255, 0),
        'blue': (0, 0, 255),
        'yellow': (255, 255, 0),
        'cyan': (0, 255, 255),
        'magenta': (255, 0, 255)
    }
    
    return color_map.get(color_str.lower(), (255, 255, 255))


def main():
    parser = argparse.ArgumentParser(description='Add date watermarks to photos based on EXIF data')
    parser.add_argument('input_dir', help='Directory containing photos to watermark')
    parser.add_argument('--font-size', type=int, default=48, help='Font size for watermark (default: 48)')
    parser.add_argument('--color', default='white', help='Watermark color: white, black, red, green, blue, yellow, cyan, magenta, or hex like #FF0000 (default: white)')
    parser.add_argument('--position', default='bottom-right', 
                       choices=['top-left', 'top-center', 'top-right', 'center', 
                               'bottom-left', 'bottom-center', 'bottom-right'],
                       help='Position of watermark (default: bottom-right)')
    
    args = parser.parse_args()
    
    # Validate input directory
    if not os.path.isdir(args.input_dir):
        print(f"Error: {args.input_dir} is not a valid directory")
        sys.exit(1)
    
    # Parse color
    color = parse_color(args.color)
    
    print(f"Photo Watermark Tool")
    print(f"Input directory: {args.input_dir}")
    print(f"Font size: {args.font_size}")
    print(f"Color: {args.color} {color}")
    print(f"Position: {args.position}")
    print("-" * 50)
    
    # Process photos
    watermark = PhotoWatermark()
    watermark.process_directory(args.input_dir, args.font_size, color, args.position)


if __name__ == "__main__":
    main()
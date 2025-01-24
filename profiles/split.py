import sys
import os

def split_segments(input_file):
    with open(input_file, 'r') as file:
        current_segment = None
        segment_data = {}
        
        for line in file:
            line = line.strip()
            if line.startswith('#'):
                if line.strip('#').strip():
                    current_segment = line.strip('#').strip()
                    segment_data[current_segment] = []
            elif line and current_segment:
                segment_data[current_segment].append(line)
        
        for segment, lines in segment_data.items():
            with open(f"{segment}", 'w') as segment_file:
                segment_file.write('\n'.join(lines) + '\n')
                
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python split_segments.py <input_file>")
        sys.exit(1)
    
    input_file = sys.argv[1]
    if not os.path.isfile(input_file):
        print("Error: Input file does not exist.")
        sys.exit(1)
    
    split_segments(input_file)


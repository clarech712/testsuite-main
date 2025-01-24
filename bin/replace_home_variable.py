import sys
import os

def replace_home_variable(file_path):
    """
    Replaces all instances of "${HOME}" with "${HOME_LOCAL}" in the given file.
    
    :param file_path: Path to the input file
    """
    if not os.path.isfile(file_path):
        print(f"Error: File '{file_path}' does not exist.")
        return

    try:
        # Read the content of the file
        with open(file_path, 'r') as file:
            content = file.read()

        # Replace "${HOME}" with "${HOME_LOCAL}"
        # updated_content = content.replace("${HOME}", "${HOME_LOCAL}")
        updated_content = content.replace("$HOME", "$HOME_LOCAL")

        # Write the updated content back to the file
        with open(file_path, 'w') as file:
            file.write(updated_content)

        print(f"Successfully replaced all instances of '${{HOME}}' with '${{HOME_LOCAL}}' in '{file_path}'.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python replace_home_variable.py <file_path>")
    else:
        file_path = sys.argv[1]
        replace_home_variable(file_path)

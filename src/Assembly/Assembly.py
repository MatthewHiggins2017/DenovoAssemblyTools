import os

def add_numbers(num1, num2):
    return num1 + num2

def main():
    result = add_numbers(3, 5)
    print(f"The result is {result}")

    # Get the absolute path of the currently running script
    script_path = os.path.abspath(__file__)
    print("Script path:", script_path)

    # Get the directory path of the currently running script.
    # This is how we can point to nextflow scripts . 
    nextflow_directory_path = os.path.dirname(os.path.dirname(os.path.dirname(script_path))) + '/NF/'
    print("Parent Directory:",nextflow_directory_path)



if __name__ == "__main__":
    main()
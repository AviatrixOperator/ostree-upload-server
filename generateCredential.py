from curses.ascii import isalnum
from passlib.hash import pbkdf2_sha256

def menu():
    print("#########################################")
    print("1) Generate a pbkdf2_sha256 password\n")
    print("2) Verify a pbkdf2_sha256 password\n")
    print("3) Exit")
    print("#########################################/n")

def validInput(word):
    while(True):
        if not word.isnumeric():
            word = (input(f"The input {word} is not a numeric value.\nPlease enter your input again: "))
            continue

        num = int(word)

        if not (num >= 0 and num <= 3):
            word = (input(f"The input {num} has to be between 1-3.\nPlease enter your input again: "))
            continue

        return num
            
if __name__ == "__main__":
    print("Hello welcome to the ostree-upload-server generator.\n")

    while(True):
        menu()
        select = validInput(input())
                
        match select:
            case 1:
                password = input("Please enter the password you like to encrypt: ")
                encrypt = pbkdf2_sha256.hash(password)
                print(f"The pbkdf2_sha256 hash ouput of {password} is : {encrypt}\n")

            case 2:
                password = input("Please enter the password (raw text) you like to verify: ")
                hash = input("Please enter the pbkdf2_sha256 hash you like to verify: ")

                if not pbkdf2_sha256.identify(hash):
                    print("This is not the right format for a pbkdf2_sha256 hash.")
                    continue

                if not pbkdf2_sha256.verify(password, hash):
                    print(f"The hash {hash} does NOT match the password {password}")
                    continue
                
                print(f"The hash {hash} DOES match the password {password}")
 
            case 3:
                print("Thank you for using the password generator 5000.")
                break

            case _:
                print("The input is invalid.")
    
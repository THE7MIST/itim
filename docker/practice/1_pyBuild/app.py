import os
import time

name = os.getenv("NAME", "User")
print(f"Hello {name}!")

for i in range (6):
    print(f"Running...")
    time.sleep(2)


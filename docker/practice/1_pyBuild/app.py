import os
import time

name = os.getenv("NAME", "User")
print(f"Hello {name}!")

for i in range(5):
    print(f"Running... {i}")
    time.sleep(2)


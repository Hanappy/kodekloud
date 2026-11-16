import os

for day in range(1, 51):
    filename = f"Day {day}.md"
    
    # Only create the file if it does not already exist
    if not os.path.exists(filename):
        with open(filename, "w", encoding="utf-8") as f:
            f.write(f"# Day {day}\n\n")
        print(f"Created: {filename}")
    else:
        print(f"Skipped (already exists): {filename}")
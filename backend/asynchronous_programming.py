import asyncio

async def count_down():
    numbers = []
    for i in range(10100000):
        numbers.append(i)
        await asyncio.sleep(0.00)  # Allow other tasks to run
    return numbers

import time
s = time.perf_counter()
asyncio.run(count_down())
elapsed = time.perf_counter() - s
print(f"{__file__} executed in {elapsed:0.2f} seconds.")
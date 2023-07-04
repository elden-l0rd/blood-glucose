import asyncio
from bleak import BleakClient, BleakScanner

# BGL100_UUID = "C0:1D:D1:90:5B:7C"
# BGL100_UUID = "4219DEB6-EAAD-FB80-7D55-0F9DC0B2CC6B"
BGL100_UUID = "89CDD248-23DE-3010-C241-1FF190ED24D6"

async def run():
    scanner = BleakScanner()
    devices = await scanner.discover()

    for device in devices:
        if (device.name == "Tim Cook's iPhone"):
            print("Device found: " + str(device))
            async with BleakClient(device) as client:
                advertisement_data = await client.read_gatt_char(BGL100_UUID)
                print("Advertisement data:", advertisement_data)


# Run the script
loop = asyncio.get_event_loop()
loop.run_until_complete(run())
import websockets
import asyncio

async def next_async_websocket(uri, packetHandler):
    """Function which awaits response from the websocket and calls the packetHandler"""
    async with websockets.connect(uri) as websocket:
        async for message in websocket:
            packetHandler(message)

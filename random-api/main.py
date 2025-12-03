import random
from typing import Dict

from fastapi import FastAPI, HTTPException

app: FastAPI = FastAPI()


@app.get("/random")  # type: ignore[misc]
async def get_random(min_nr: int, max_nr: int) -> Dict[str, int]:
    if min_nr > max_nr:
        raise HTTPException(
            status_code=400, detail="min_nr must be less than or equal to max_nr"
        )

    return {"value": random.randint(min_nr, max_nr)}

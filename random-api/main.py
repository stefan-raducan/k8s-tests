import random
from typing import Dict

from fastapi import FastAPI, HTTPException
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

# Setup OpenTelemetry
resource = Resource.create(attributes={SERVICE_NAME: "random-api"})
provider = TracerProvider(resource=resource)
processor = BatchSpanProcessor(OTLPSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

app: FastAPI = FastAPI()

FastAPIInstrumentor.instrument_app(app)


@app.get("/random")  # type: ignore[misc]
async def get_random(min_nr: int, max_nr: int) -> Dict[str, int]:
    if min_nr > max_nr:
        raise HTTPException(
            status_code=400, detail="min_nr must be less than or equal to max_nr"
        )

    return {"value": random.randint(min_nr, max_nr)}

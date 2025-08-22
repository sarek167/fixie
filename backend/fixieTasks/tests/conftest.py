import sys
import types
import pytest

class _DummyKafkaFuture:
    def get(self, timeout=None): return None

class _DummyKafkaProducer:
    def __init__(self, *args, **kwargs):
        self._init = (args, kwargs)
        self.sent = []
    def send(self, topic, value):
        self.sent.append((topic, value))
        return _DummyKafkaFuture()
    def flush(self): pass
    def close(self): pass

kafka_mod = types.ModuleType("kafka")
kafka_mod.KafkaProducer = _DummyKafkaProducer
sys.modules["kafka"] = kafka_mod

kafka_errors = types.ModuleType("kafka.errors")
class NoBrokersAvailable(Exception): pass
kafka_errors.NoBrokersAvailable = NoBrokersAvailable
sys.modules["kafka.errors"] = kafka_errors

def _fake_decode_jwt(token: str):
    return {"user_id": 1}

utils_jwt = types.ModuleType("utils.jwt_utils")
utils_jwt.decode_jwt = _fake_decode_jwt
utils_jwt.PUBLIC_KEY = "-----BEGIN PUBLIC KEY-----\nFAKE\n-----END PUBLIC KEY-----"
sys.modules["utils.jwt_utils"] = utils_jwt

fixie_utils_jwt = types.ModuleType("fixieAvatar.utils.jwt_utils")
fixie_utils_jwt.decode_jwt = _fake_decode_jwt
fixie_utils_jwt.PUBLIC_KEY = utils_jwt.PUBLIC_KEY
sys.modules["fixieAvatar.utils.jwt_utils"] = fixie_utils_jwt

@pytest.fixture(autouse=True, scope="session")
def _loaded():
    yield

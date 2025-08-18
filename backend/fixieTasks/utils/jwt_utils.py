import logging
from pathlib import Path
from django.conf import settings
import jwt

log = logging.getLogger(__name__)

def _read_public_key():
    path = getattr(settings, "PUBLIC_KEY_PATH", "/etc/secrets/jwt/public.pem")
    try:
        p = Path(path)
        if not p.exists():
            log.error("PUBLIC_KEY_PATH does not exist: %s", path)
            raise FileNotFoundError(f"Public key not found at {path}")
        text = p.read_text()
        if "BEGIN" not in text:
            log.error("Public key file at %s doesn't look like PEM", path)
        log.info("Using public key path: %s (size=%d bytes)", path, len(text))
        return text
    except Exception as e:
        log.exception("Cannot read PUBLIC_KEY_PATH=%s: %s", path, e)
        raise

def decode_jwt(token: str):
    try:
        if not token:
            raise ValueError("Missing token")
        log.info("Decoding JWT (len=%d, prefix=%s)", len(token), token[:12])
        public_key = _read_public_key()

        payload = jwt.decode(token, public_key, algorithms=["RS256"])

        log.info("JWT OK. sub=%s exp=%s iss=%s", payload.get("sub"), payload.get("exp"), payload.get("iss"))
        return payload
    except jwt.ExpiredSignatureError:
        log.info("JWT expired")
        raise ValueError("Token expired")
    except jwt.InvalidTokenError as e:
        log.info("JWT invalid: %s", e)
        print(f"JWT invalid: {e}")
        log.info(f"\nkey: {public_key}\n")
        raise ValueError(f"Incorrect token: {token} for key {public_key}")
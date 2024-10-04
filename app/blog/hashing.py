from passlib.context import CryptContext

pwd_cxt = CryptContext(schemes=["pbkdf2_sha256"], deprecated="auto")

class Hash():
    def hash_password(password: str):
        return pwd_cxt.hash(password)

    def verify(hashed_password,plain_password):
        return pwd_cxt.verify(plain_password,hashed_password)
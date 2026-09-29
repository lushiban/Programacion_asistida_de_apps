import os

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from supabase import create_client

load_dotenv()

supabase = create_client(
    os.environ["SUPABASE_URL"],
    os.environ["SUPABASE_SECRET"],
)

app = FastAPI()


class NuevoUsuario(BaseModel):
    correo: str
    clave: str
    nombre: str


@app.post("/usuarios")
def crear_usuario(u: NuevoUsuario):
    try:
        respuesta = supabase.auth.admin.create_user(
            {
                "email": u.correo,
                "password": u.clave,
                "email_confirm": True,
            }
        )
        id_del_usuario = respuesta.user.id
        supabase.table("perfiles").insert(
            {"id": id_del_usuario, "nombre": u.nombre}
        ).execute()
        return {"ok": True, "id": id_del_usuario}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

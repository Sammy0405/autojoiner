import discord
import requests  # Asegúrate de tener esta librería instalada: pip install requests

TOKEN = "NTUzNzE2NzY3MjI3MTE3NTg4.GDQbKs.I-dVDSLHgYBBVAsD4_oBikdiXEudcuPcfz-1no"
CANAL_ID = 1401775061706346536  # Cambia por el ID del canal de Discord a monitorear

PALABRAS_CLAVE = ['La Vacca Saturno Saturnita', 'Chimpanzini Spiderini']
SERVER_URL = "http://localhost:5000/endpoint"  # Cambia esta URL por la de tu servidor Flask

class FinderSelfbot(discord.Client):
    async def on_ready(self):
        print(f"[FinderBot] Conectado como {self.user}")

    async def on_message(self, message):
        # Solo procesar los mensajes de los bots que contienen los datos relevantes
        if message.author.bot:
            print(f"MENSAJE DE OTRO BOT: {message.author}")
            print(f"Contenido del mensaje: {message.content}")  # Verificar el contenido
            if message.embeds:
                for embed in message.embeds:
                    print(f"--- EMBED ---")
                    embed_data = {}
                    if embed.title:
                        embed_data['title'] = embed.title
                    if embed.description:
                        embed_data['description'] = embed.description
                    if embed.fields:
                        embed_data['fields'] = {}
                        for field in embed.fields:
                            embed_data['fields'][field.name] = field.value
                    print(f"Embed Data: {embed_data}")  # Ver los datos del embed
                    self.enviar_a_servidor(embed_data)  # Enviar los datos del embed

        # Filtro normal de tu canal, para que también puedas capturar los mensajes que contengan las palabras clave
        if message.channel.id == CANAL_ID:
            if any(palabra in message.content.lower() for palabra in PALABRAS_CLAVE):
                print("[FinderBot] ¡Encontrado mensaje relevante!")
                print(message.content)
                # Enviar el contenido del mensaje al servidor Flask si no está vacío
                if message.content.strip():  # Solo enviar si el contenido no está vacío
                    self.enviar_a_servidor(message.content)
                else:
                    print("[FinderBot] Mensaje vacío, no enviado al servidor.")

    def enviar_a_servidor(self, mensaje):
        # Imprimir el mensaje antes de enviarlo para ver si tiene sentido
        print(f"Mensaje a enviar al servidor: {mensaje}")

        # Crear el payload que el servidor Flask recibirá
        datos = {
            "mensaje": mensaje
        }
        
        print(f"Enviando al servidor: {datos}")  # Verificar qué está enviando el bot
        
        response = requests.post(SERVER_URL, json=datos)
        if response.status_code == 200:
            print("[FinderBot] Datos enviados correctamente al servidor.")
        else:
            print("[FinderBot] Error al enviar datos al servidor:", response.status_code)

client = FinderSelfbot()
client.run(TOKEN)

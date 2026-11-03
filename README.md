# Open WebUI + pgvector

## Voraussetzungen

- Docker Desktop 4.52.0+ (oder Docker Engine mit Compose v2)
- `openssl` zum generieren der Secrets
- `curl`, `python3` für das Skript zum testen der API verbindung (optional)
- *Windows*: `Git Bash` (hat `curl` und `openssl` vorinstalliert und kann Bash-Skripte ausführen, ggf. Python nachinstallieren)

## Aufsetzen

### `.env` vorbereiten

```bash
cp .env.example .env
```

- API-Key eintragen
- Zwei Secrets generieren (kann auch ein beliebiges Passwort sein)
```bash
openssl rand -hex 32
````
- Jeweils bei `POSTGRES_PASSWORD` und `WEBUI_SECRET_KEY` eintragen

### Container starten

#### API-Check durchführen

```bash
./check-api.sh
````

#### Container starten

```bash
docker compose up -d
```

## Einrichtung

- Open WebUI unter http://localhost:3000 öffnen
- Mit beliebiger E-Mail-Adresse und Passwort registrieren (Erster Registrierter Nutzer wird Admin)
- Deepseek Model sollte direkt im Chat verfügbar sein

### Wissensbasis anlegen

- Oben Links *Arbeitsbereich* > *Wissen* > *Erstellen* 
  - Woran arbeiten Sie?: Beliebigen Namen eintragen
  - Was möchten Sie erreichen?: Beliebige Beschreibung eintragen
- *Wissen erstellen*
- *+* wählen > PDF-Dateien hochladen
- Die Wissensbasis kann dann über Eingeben von `#` referenziert und in die Anfrage mit einbezogen werden

### Wissensbasis direkt in Anfragen inkludieren (optional)

- Oben Links *Arbeitsbereich* > *Modelle* > *Erstellen* 
  - Modellname: Beliebig, z.B. "GISA Chatbot"
  - Basismodell: DeepSeek-V4-Flash-0731
  - Systemprompt: "Du bist Experte für die Marktkommunikation Strom. Antworte auf Deutsch. Nenne einen Nachrichtentyp oder Prüfidentifikator nur, wenn die Quelle ihn ausdrücklich für diesen Use-Case nennt, sonst sag, dass die Quelle es offen lässt. Berücksichtige alle Marktrollen (NB, LF, MSB). Gib keine Zwischenschritte aus."
  - Wissen: Gerade erstellte Wissensbasis auswählen
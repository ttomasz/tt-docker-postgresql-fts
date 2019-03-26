## README
Skrypt Dockerfile pozwalający uruchomić w kontenerze bazę PostgreSQL 11 z wbudowanym Polskim słownikiem do Full Text Search oraz dodatkiem PostGIS.

Bazowany na instrukcji z:
https://github.com/dominem/postgresql_fts_polish_dict

## Uruchomienie:
Najpierw budujemy obraz komendą (uruchamiając z katalogu z plikami):
```
docker build -t <nazwa> .
```
Następnie uruchamiamy kontener:
```
docker run <nazwa>
```


Parametry z oficjalnego dockera postgresql powinny działać bez problemu jako iż ten obraz na nim bazuje.
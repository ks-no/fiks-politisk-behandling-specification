## Hent møteplan

### Klassediagram
*Merk at denne kan være litt utdatert*

![klasseidagram](klassediagram/klassediagram-møteplan-hent.png)


### Sekvensdiagram
#### Hent møteplan ok med resultat melding i retur:
![sekvensdiagram](sekvensdiagram/sekvensdiagram-møteplan-hent.png)

#### Hent møteplan feiler med ikke funnet i retur:
Det skal kun sendes en `ikkefunnet` melding hvis det er feil i hent-parameterene. 
Det skal ikke sendes en `ikkefunnet` hvis det ikke er funnet noen møter i perioden man har søket på.
Da skal det returneres et tomt resultat.

![sekvensdiagram](sekvensdiagram/sekvensdiagram-møteplan-hent-ikkefunnet.png)

#### Hent møteplan feiler med ugyldigforespørsel i retur:
![sekvensdiagram](sekvensdiagram/sekvensdiagram-møteplan-hent-ugyldigforespoersel.png)

#### Hent møteplan feiler med serverfeil i retur:
![sekvensdiagram](sekvensdiagram/sekvensdiagram-møteplan-hent-serverfeil.png)
# Invoice Collector

Deine zentrale Sammelstelle für Online-Rechnungen.
Der InvoiceCollector loggt sich für dich bei verschiedenen Anbietern, sowie in IMAP-Accounts ein und lädt die vorgefundenen PDF-Rechnungen in ein lokales Archiv.
Je nach Anbieter werden auch Datum, Nummer und Betrag der Rechnung gespeichert.

## Unterstütze Anbieter

* amazon
* arcor (Vodafone D2 GmbH)
* affilinet (affilinet GmbH)
* binlayer (Binlayer GmbH)
* dhlbusiness (DHL Geschäftskunden)
* hetzner (Hetzner Online AG)
* hexonet (HEXONET GmbH)
* hosteurope (Host Europe GmbH)
* jacob_elektronik (Jacob Elektronik GmbH)
* keyweb (Keyweb AG)
* linklift (LinkLift Ltd.)
* oekopost (Oekopost Deutschland GmbH)
* omg (OMG.de GmbH)
* pluscard (PLUSCARD Service-Gesellschaft für Kreditkarten-Processing mbH - Kreditkartenabrechnungen von MasterCard/Visa)
* schlundtech (Schlund Technologies GmbH)
* simplytel (simply Communication GmbH)
* sipgate (Sipgate GmbH)
* sistrix (SISTRIX GmbH)
* sponsorads (Sponsorads GmbH & Co. KG)
* strato (Strato AG)
* swb (swb AG)
* textbroker (Sario Marketing GmbH)
* twenty_three_media (23Media GmbH)
* vodafone (Vodafone D2 GmbH)

## IMAP-Support

Über das Frontend können IMAP-Accounts und IMAP-Filter angelegt werden.
Nach erfolgreicher Verbindung mit dem IMAP-Server werden die Emails über konfigurierbare Suchausdrücke vorgefiltert.
Aus den gefundenen Emails werden dann über reguläre Ausdrücke Betreff und Dateiname des Anhangs geprüft, um nur die echten Rechnungen zu finden.

## Installation

Voraussetzungen sind `git, ruby 1.9.2` und `bundler`.
Für die Druckunterstützung wird außerdem `lpr-cups` mit einem installierten Drucker benötigt.

    git clone http://github.com/digineo/invoice_collector.git
    cd invoice_collector
    gem install bundler
    bundle install
    rake db:create
    rake db:migrate

## Bedienung

### Rechnungen einsammeln
    rails runner Account.fetch_all

Wenn eine `Fetcher::LoginException` geworfen wird, sind möglicherweise die Zugangsdaten für den angezeigten Account ungültig.

### Frontend

Das Frontend wird gestartet mit:

    rails server -b 127.0.0.1

Damit ist es per unter `http://localhost:3000/` erreichbar.
Beenden werden kann es mit `STRG + C`.

## Erweiterung
Vermisst du einen Anbieter mit Online-Rechnungen?
Dann erstell einfach ein weiteres Modul unter `/lib/fetcher/`, welches von `Fetcher::Base` erbt.

✅ To-Do-Checkliste für die Einrichtung einer Managed Instance Group (MIG) mit Multi-Zone-Failover für Preemptible VMs auf GCP

🔧 1. Projekt und Umgebung vorbereiten
	•	Google Cloud CLI installieren: GCP SDK installieren
	•	GCP-Projekt auswählen:
```bash
gcloud config set project [PROJECT_ID]
```
	•	Region und Zonen als Umgebungsvariablen festlegen:
```bash
export REGION=europe-west3
export ZONES="europe-west3-a,europe-west3-b,europe-west3-c"
export INSTANCE_NAME=k3s-worker
export TEMPLATE_NAME=k3s-template
export MIG_NAME=k3s-mig
```
📄 2. Instanzvorlage (Instance Template) erstellen

Eine Instanzvorlage definiert die Konfiguration für alle VMs in der MIG.
```bash
gcloud compute instance-templates create $TEMPLATE_NAME \
  --machine-type=e2-small \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --tags=k3s,worker \
  --preemptible
```
🌍 3. Multi-Zone-Managed Instance Group (MIG) erstellen

Erstelle eine MIG, die VMs über mehrere Zonen verteilt:
```bash
gcloud compute instance-groups managed create $MIG_NAME \
  --base-instance-name $INSTANCE_NAME \
  --template=$TEMPLATE_NAME \
  --size=3 \
  --zones=$ZONES
```
🔄 4. Automatische Skalierung aktivieren (optional)

Richte automatische Skalierung auf Basis der CPU-Auslastung ein:
```bash
gcloud compute instance-groups managed set-autoscaling $MIG_NAME \
  --max-num-replicas=6 \
  --min-num-replicas=3 \
  --target-cpu-utilization=0.6 \
  --cool-down-period=90
```
🔐 5. Firewall-Regeln konfigurieren

Öffne die erforderlichen Ports für den Zugriff (z. B. SSH oder K3s):
```bash
gcloud compute firewall-rules create allow-k3s-traffic \
  --allow=tcp:6443 \
  --target-tags=k3s
```
🔍 6. Überprüfen, ob die MIG funktioniert
	+	Status der Instanzen überprüfen:
```bash
gcloud compute instance-groups managed list-instances $MIG_NAME --region=$REGION
```

+ Sicherstellen, dass die VMs in verschiedenen Zonen laufen:
```bash
gcloud compute instances list --filter="name~'$INSTANCE_NAME'"
```
🛠️ 7. Automatische Reparatur aktivieren (optional)

Falls eine Instanz ausfällt, sorgt die automatische Reparatur für Ersatz:
```bash
gcloud compute instance-groups managed update $MIG_NAME \
  --region=$REGION \
  --enable-health-check
```
🧹 8. Aufräumen (Ressourcen löschen, wenn nicht mehr benötigt)
```bash
gcloud compute instance-groups managed delete $MIG_NAME --region=$REGION
gcloud compute instance-templates delete $TEMPLATE_NAME
```

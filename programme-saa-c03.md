# Programme de formation — AWS Certified Solutions Architect – Associate (SAA-C03)

## Référentiel officiel (vérifié le 10/10/2026)

- **Version en vigueur : SAA-C03** (guide v1.1). Aucune « SAA-C04 » n'a été publiée par AWS : se méfier des ressources qui l'annoncent.
- **Format :** 65 questions (50 notées, 15 non notées et non signalées), 130 minutes.
- **Types de questions :** choix unique (1 bonne réponse sur 4) ou réponses multiples (au moins 2 bonnes sur 5 options ou plus).
- **Notation :** aucune pénalité pour une mauvaise réponse. Score de 100 à 1 000, 720 pour réussir. Notation compensatoire : seul le score global compte.

### Domaines et pondérations

| Domaine | Poids |
|---|---|
| D1 — Concevoir des architectures sécurisées | 30 % |
| D2 — Concevoir des architectures résilientes | 26 % |
| D3 — Concevoir des architectures performantes | 24 % |
| D4 — Concevoir des architectures optimisées en coûts | 20 % |

### Énoncés de tâches

- 1.1 Concevoir des accès sécurisés aux ressources AWS
- 1.2 Concevoir des workloads et applications sécurisés
- 1.3 Déterminer les contrôles de sécurité des données appropriés
- 2.1 Concevoir des architectures scalables et faiblement couplées
- 2.2 Concevoir des architectures hautement disponibles et/ou tolérantes aux pannes
- 3.1 Stockage performant et/ou scalable
- 3.2 Calcul performant et élastique
- 3.3 Bases de données performantes
- 3.4 Architectures réseau performantes et/ou scalables
- 3.5 Ingestion et transformation de données performantes
- 4.1 à 4.4 Stockage, calcul, bases de données et réseau optimisés en coûts

---

## Ajustements par rapport au plan initial

- **Leçon 0 ajoutée :** sécuriser le compte de lab avant de créer la moindre ressource.
- **CloudFormation dès le module 1 :** tous les labs deviennent reproductibles et faciles à supprimer.
- **Load balancers et tarification EC2** déplacés dans le module Calcul.
- **WAF et CloudFront** regroupés dans la partie Réseau, périphérie (edge).
- **Module ajouté :** Données et analytique (domaine 3.5).
- **CI/CD marquée (Pro) :** utile en pratique, peu présente à l'examen.

---

## Programme détaillé

Légende : ★ facile · ★★ intermédiaire · ★★★ avancé.

### L0 — Compte de lab sécurisé · ★ · ~2 h

MFA sur le compte root, IAM Identity Center, AWS CLI v2 avec identifiants temporaires, alertes AWS Budgets, conventions de tags.

### M1 — Fondations architecturales · D2 · ★ · ~6 h

- **Objectif :** raisonner en « rayon d'impact » des pannes, et lire un énoncé comme une liste d'exigences.
- **Leçons :**
  - Infrastructure globale (Régions, AZ, Local Zones, Outposts, Wavelength)
  - Well-Architected appliqué aux scénarios
  - Premiers stacks CloudFormation
- **Lab :** déployer, faire évoluer et supprimer un stack CloudFormation.

### M2 — IAM et gouvernance multi-comptes · D1.1 · ★★ · ~10 h

- **Objectif :** concevoir des accès au moindre privilège.
- **Leçons :**
  - Évaluation des policies (deny explicite, policies d'identité ou de ressource, conditions)
  - Rôles, STS, accès entre comptes
  - Fédération : IAM Identity Center, Cognito
  - Organizations, SCP, Control Tower, RAM, permission boundaries
- **Lab :** rôle assumé entre comptes (variante dans un seul compte si besoin).

### M3 — Protection des données et détection · D1.2–1.3 · ★★ · ~8 h

- **Objectif :** choisir les bons contrôles pour chaque exigence de chiffrement, de secrets ou d'audit.
- **Leçons :**
  - KMS (chiffrement d'enveloppe, key policies, clés multi-régions)
  - Secrets Manager ou Parameter Store
  - ACM
  - CloudTrail, Config, GuardDuty, Macie, Inspector, Security Hub
- **Lab :** bucket S3 chiffré avec SSE-KMS, key policy restrictive, test d'accès refusé.

### M4 — Réseau · D1, D3.4, D4.4 · ★★★ · ~14 h

- **Objectif :** concevoir et dépanner un VPC multi-AZ.
- **Leçons :**
  - Plan d'adressage CIDR, sous-réseaux, tables de routage
  - Sortie privée vers Internet (NAT Gateway, IPv6)
  - Security Groups ou NACL, Flow Logs, Network Firewall
  - VPC endpoints et PrivateLink
  - Peering, Transit Gateway, VPN, Direct Connect
  - Route 53
  - CloudFront, Global Accelerator, WAF et Shield
  - Coûts de transfert
- **Labs :** VPC complet en CloudFormation · comparaison endpoint et NAT · diagnostic par Flow Logs.
- ⚠️ La NAT Gateway et les adresses IPv4 publiques sont facturées à l'heure.

### M5 — Calcul · D2, D3.2, D4.2 · ★★ · ~14 h

- **Objectif :** choisir entre machine virtuelle, conteneur et fonction serverless, puis le modèle tarifaire adapté.
- **Leçons :**
  - EC2 (familles, placement groups, IMDSv2)
  - ALB, NLB, GWLB
  - Auto Scaling
  - Lambda (concurrence, limites, accès au VPC)
  - ECS, Fargate, EKS
  - Beanstalk, Batch
  - On-Demand, Savings Plans, Reserved Instances, Spot
- **Lab :** ALB et Auto Scaling sur plusieurs AZ, avec destruction d'une instance pour observer l'auto-réparation.

### M6 — Stockage · D3.1, D4.1 · ★★ · ~10 h

- **Leçons :**
  - S3 en profondeur (classes, lifecycle, réplication, Object Lock, presigned URLs, Block Public Access)
  - EBS et instance store
  - EFS et les variantes FSx
  - Storage Gateway, DataSync, Transfer Family, famille Snow
  - AWS Backup
- **Lab :** site S3 servi par CloudFront avec OAC, plus des règles de lifecycle.

### M7 — Bases de données · D2.2, D3.3, D4.3 · ★★★ · ~14 h

- **Leçons :**
  - RDS (Multi-AZ, read replicas, RDS Proxy)
  - Aurora (Serverless v2, Global Database)
  - DynamoDB (modélisation, index GSI/LSI, modes de capacité, DAX, Streams, Global Tables)
  - ElastiCache et stratégies de cache
  - Bases spécialisées (niveau reconnaissance)
  - DMS
- **Lab :** modéliser une table DynamoDB pilotée par ses patterns d'accès, et provoquer un basculement RDS (version économique proposée).

### M8 — Découplage et événements · D2.1 · ★★★ · ~12 h

- **Leçons :**
  - SQS Standard ou FIFO, visibilité, DLQ
  - SNS et fan-out
  - EventBridge
  - Step Functions
  - API Gateway et AppSync
  - Idempotence, retries, backpressure, ordre des messages
- **Lab :** pipeline API Gateway → Lambda → SQS, avec un message « poison » qui finit en DLQ.

### M9 — Ingestion et analytique (nouveau) · D3.5 · ★★ · ~8 h

- **Leçons :**
  - Kinesis Data Streams, Firehose ou MSK
  - Glue, Athena, Lake Formation
  - EMR, Redshift, OpenSearch, QuickSight
  - Services d'IA managés (choisir selon le cas d'usage)
- **Lab :** Firehose vers S3 au format Parquet, puis Glue et Athena.

### M10 — Haute disponibilité et reprise après sinistre · D2.2 · ★★★ · ~10 h

- **Leçons :**
  - RTO et RPO
  - Les 4 stratégies de reprise : backup/restore, pilot light, warm standby, active-active
  - Multi-régions (bascule Route 53, Aurora Global, Global Tables, réplication S3)
  - Elastic Disaster Recovery
  - Dégradation contrôlée
- **Lab niveau 3 :** bascule entre deux régions en pilot light minimal.

### M11 — Exploitation et observabilité · ★★ · ~8 h

- **Leçons :**
  - CloudFormation avancé (change sets, StackSets)
  - Systems Manager (Session Manager, Patch Manager)
  - CloudWatch et X-Ray
  - Déploiements blue/green et canary
  - CI/CD (Pro)
- **Lab :** administrer une instance sans SSH ni bastion, plus une alarme qui notifie via SNS.

### M12 — Coûts et performance (synthèse) · D4 · ★★ · ~6 h

- **Leçons :**
  - Cost Explorer, Budgets, tags de répartition des coûts
  - Trusted Advisor, Compute Optimizer
  - Exercices d'arbitrage coût, performance et disponibilité

### M13 — Architectures intégrées et migration · ★★★ · ~10 h

- **Leçons :**
  - Architecture 3 tiers
  - SaaS multi-tenant
  - API serverless
  - Connectivité hybride
  - Migration (les « 7 R », Application Migration Service, DMS)

### M14 — Préparation finale · ~15 h

- **Contenu :**
  - Révision par domaine
  - Analyse des distracteurs
  - 2 à 3 examens blancs chronométrés (65 questions en 130 min)
  - Remédiation ciblée
- **Verdict de préparation :** basé sur les résultats aux examens blancs et la capacité à justifier ses choix, pas sur le simple fait d'avoir fini les leçons.

**Total estimé :** environ 145 h, soit 3 à 4 mois à raison de 10 h par semaine.

---

## Grands labs d'intégration

1. **Après M5 :** application web 3 tiers hautement disponible (ALB, Auto Scaling, RDS) entièrement en CloudFormation.
2. **Après M8 :** plateforme de commandes asynchrone et serverless.
3. **Après M9 :** mini data lake.
4. **Après M10 :** reprise après sinistre multi-régions.
5. **Après M13 :** projet final SaaS multi-tenant, avec une revue Well-Architected.

---

## Prérequis

- Un compte AWS personnel dédié aux labs, jamais un compte professionnel.
- AWS CLI v2, Git, un éditeur de code.
- Des bases en bash, JSON et YAML.
- Des notions de TCP/IP, DNS et découpage en sous-réseaux (le découpage CIDR est révisé au module 4).
- Un peu de Python pour les fonctions Lambda.

Chaque lab est chiffré avant d'être lancé. Les conditions de l'offre gratuite dépendent de la date de création du compte et sont vérifiées à la leçon 0.

---

## Références officielles

- Guide d'examen SAA-C03 : https://docs.aws.amazon.com/aws-certification/latest/examguides/solutions-architect-associate-03.html
- AWS Well-Architected Framework : https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html
- Livre blanc *Disaster Recovery of Workloads on AWS* : https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-workloads-on-aws.html
- Référence AWS CLI : https://docs.aws.amazon.com/cli/latest/
- Référence des ressources CloudFormation : https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/introduction.html
- AWS Pricing Calculator : https://calculator.aws/
- AWS Skill Builder (questions et examen d'entraînement officiels) : https://skillbuilder.aws/
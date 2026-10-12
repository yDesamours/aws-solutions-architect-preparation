# Leçon 0 — Corrigé

> ⚠️ **Spoilers.** Ouvre ce fichier seulement après avoir répondu dans le chat aux questions et aux exercices de réflexion.

---

## Questions de vérification

**1. Identifiant temporaire volé ou clé d'accès volée ?**

Au moment du vol, les permissions sont identiques. La différence porte sur la **fenêtre d'exposition** :
- **Clé d'accès :** elle reste valable jusqu'à ce que quelqu'un s'aperçoive de la fuite et la révoque, ce qui peut prendre des semaines.
- **Identifiants temporaires :** ils expirent seuls.

Nuance importante avec `aws login` : le cache contient de quoi **rafraîchir** les identifiants toutes les 15 minutes jusqu'à la fin de la session (12 h maximum). Un vol du cache donne donc jusqu'à environ 12 h d'accès, pas 15 minutes. Après cette limite, il faut une nouvelle authentification avec mot de passe et MFA, que le voleur n'a pas.

**2. Budget silencieux alors que 25 USD de crédits ont été consommés**

Explication la plus probable : le budget **inclut les crédits** (`IncludeCredit` vaut `true` par défaut). Le coût net, après crédits, est d'environ 0 USD, donc aucun seuil n'est franchi.

Causes secondaires possibles : délai de mise à jour des données de facturation, ou budget créé après la dépense, sur une autre période.

**3. Option B ou option A**

L'option B est supérieure parce qu'elle ne crée **aucun utilisateur IAM** à mot de passe permanent. Les identités sont centralisées et ton compte est prêt pour le multi-comptes. Les permission sets sont des modèles réutilisables, et les sessions sont toujours des rôles temporaires.

On ne la choisit pas forcément tout de suite parce qu'elle nécessite **AWS Organizations**. Sur le plan gratuit, l'activer fait passer le compte au plan payant et retire la protection « aucune facture » pendant la période gratuite. C'est un compromis entre sécurité et maîtrise du risque financier, à décider en connaissance de cause.

---

## Questions de type SAA-C03

**Q1 → B.**
- B : Identity Center et les permission sets fournissent des identifiants temporaires multi-comptes, gérés en un seul endroit.
- A : des identifiants permanents (interdits), et 40 × 12 utilisateurs à gérer.
- C : des clés d'accès permanentes, interdites par l'énoncé.
- D : des identifiants partagés, donc aucune traçabilité individuelle et aucun moindre privilège par personne.

**Q2 → B.**
- B : seul AWS Budgets gère nativement une alerte sur le coût **prévu**, sans développement.
- A : `EstimatedCharges` n'est publiée qu'en **us-east-1** (pas « dans la Région des ressources ») et porte sur le réel.
- C : fonctionne, mais demande du développement, ce que l'énoncé veut éviter.
- D : Cost Anomaly Detection repère des dépenses **inhabituelles** par rapport à l'historique, pas le franchissement d'un seuil prévisionnel.

**Q3 → A et C.**
- B : il ne faut jamais créer de clés root. Une CI/CD utilise un rôle.
- D : on ne partage jamais root, MFA ou pas.
- E : root ne sert pas à l'administration quotidienne, quel que soit le réseau.

---

## Exercices de réflexion

### Exercice 1 — Portable volé, terminal ouvert

**Ce que peut faire le voleur :**
- Tout ce que permet `AdministratorAccess`, en utilisant le cache de `~/.aws/login/cache`, jusqu'à la fin de la session (≤ 12 h).
- Si une session console est ouverte dans le navigateur, la même chose en console.
- Il ne peut **pas** se réauthentifier : il lui manque ton mot de passe et ton MFA.

**Réponse dans l'heure, depuis un autre appareil :**

1. **Couper les permissions immédiatement.** Connecte-toi en **root** et retire `lab-admin` du groupe `lab-admins`, ou ajoute à l'utilisateur une policy inline de refus total.
   - 📘 IAM évalue les permissions **à chaque requête**. Retirer les droits de l'utilisateur rend donc inutiles *tous* ses identifiants en cours, temporaires compris, sans attendre leur expiration.
   - C'est plus fiable que de compter sur l'expiration de la session.
2. Change le mot de passe de `lab-admin` et réinitialise son dispositif MFA si le téléphone a aussi été volé.
3. **Enquêter.** Consulte l'historique des événements CloudTrail (90 jours, gratuit, activé par défaut) et filtre sur l'utilisateur `lab-admin`. Regarde **toutes les Régions** : un attaquant crée souvent des ressources loin de ta Région habituelle.
4. Supprime toute ressource ou identité créée par l'attaquant. Cherche en particulier de **nouveaux utilisateurs IAM ou de nouvelles clés d'accès**, une technique de persistance classique. Ensuite seulement, restaure les droits.

**Variante avec l'option B :** désactive l'utilisateur ou retire son affectation dans Identity Center. Attention : les sessions de rôle déjà émises restent valides jusqu'à la fin de leur durée (celle du permission set, 1 h par défaut). Il faut donc aussi révoquer les sessions actives du rôle `AWSReservedSSO_…` (fonction **Revoke active sessions** du rôle dans IAM). On approfondira au M2.

**Prévention :** chiffrement du disque, verrouillage automatique de l'écran, `aws logout` en fin de séance.

✂️ Le mécanisme de révocation des sessions basé sur la date d'émission du jeton (`aws:TokenIssueTime`) sera vu au M2. Je n'ai pas vérifié son comportement exact avec les identifiants émis par `aws login` : la coupure des permissions de l'utilisateur, décrite au point 1, reste la méthode sûre.

### Exercice 2 — Bloquer la création de ressources au-delà de 30 USD

**Mécanisme :** une **action de budget** (*budget action*), déclenchée à 30 USD. Elle peut :
- appliquer une **policy IAM** de refus à un utilisateur, un groupe ou un rôle (ici, au groupe `lab-admins`) ;
- appliquer une **SCP**, mais cela nécessite Organizations ;
- **arrêter** des instances EC2 ou RDS ciblées.

Elle s'exécute automatiquement ou après ton approbation, et nécessite un rôle IAM d'exécution pour Budgets. Les deux premiers budgets avec actions sont gratuits.

**Limites :**
- Les données de facturation arrivent avec retard : tu **dépasseras** le seuil avant que l'action ne se déclenche.
- Interdire la création n'arrête pas ce qui tourne déjà : une NAT Gateway ou un ALB continuent d'être facturés. L'arrêt EC2/RDS ne cible que les instances désignées.
- C'est un garde-fou, pas un plafond strict. AWS ne propose pas de plafond de dépense dur sur un compte payant.

**Risque introduit : te verrouiller toi-même dehors.** Si la policy de refus vise ton propre groupe, tu ne peux plus réparer en tant que `lab-admin`.

Parade : garder un accès **break-glass**. Dans un compte autonome, **root n'est pas affecté** par les policies IAM : tu te connectes en root, tu retires la policy et tu corriges. Note que ce scénario est l'un des rares usages légitimes de root.

Autre parade : rendre l'action **à approbation manuelle**, pour décider toi-même quand l'appliquer.

### Exercice 3 — Un ami veut suivre le cours avec toi

| Approche | Isolation | Coûts | Verdict |
|---|---|---|---|
| Partager `lab-admin` ou root | Nulle, aucune traçabilité | Partagés | ❌ Jamais |
| Utilisateur IAM dédié dans ton compte, MFA, droits limités | Faible : même compte, même facture, il voit ou casse tes ressources | Sur ta facture | ⚠️ Acceptable pour du dépannage ponctuel |
| Utilisateur Identity Center dans ton organisation, avec **son propre compte membre** | Forte : comptes séparés, facture consolidée chez toi | Sur ta facture | ✅ Si tu acceptes de payer |
| **Son propre compte AWS**, totalement indépendant | Totale | Sur **sa** facture, avec **ses** crédits du Free Tier s'il est nouveau client | ✅✅ Le meilleur choix ici |

🏗️ **Principe :** le **compte AWS est la frontière d'isolation la plus forte**. Le rayon d'impact, la facturation et les quotas sont tous séparés. C'est exactement l'idée qui justifie les architectures multi-comptes du M2.

---

## Points d'évaluation que je regarderai dans tes réponses

- As-tu distingué **détectif** (Budgets) et **préventif** (policy de refus, SCP) ?
- As-tu pensé à **toutes les Régions** pendant l'enquête ?
- As-tu identifié le risque d'**auto-verrouillage** et proposé une sortie (break-glass) ?
- As-tu raisonné en **rayon d'impact** plutôt qu'en liste de services ?
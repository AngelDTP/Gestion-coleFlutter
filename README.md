[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/rCJfMrtv)


## Structures de la base de données
Collection Utilisateurs (utilisateurs)
Contient un email (email: string)
L'url d'une image pour la photo de profil (image_url: string)
matricule (matricule: string)
nom (nom: string)
prénom (prenom: string)
role (role: string) qui va varier entre Eneignant, Administrateur ou Etudiant.

Collection Classes (classes)
contient l'email d'un enseignant (Enseignant: string)
un array d'étudiants (Etudiants: [])
un numero de cours (Num_Cours: string)
un numéro de groupe (Num_Groupe: num)
un array de périodes (Periode_Cours: [])

Collection de présences (presences)
contient un étudiant a qui il appartient (Etudiants: string)
une date (Jour: string)
un numéro de cours (Num_Cours: string)
une boolean qui vérifie si il est présent (Present: bool)

## Pas fait les règles de sécurité puisque j'ai remarqué que je devrais tout readapter mon code (J'ai une idée de comment le faire par contre juste manque de temps :(  )
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // This rule allows anyone with your Firestore database reference to view, edit,
    // and delete all data in your Firestore database. It is useful for getting
    // started, but it is configured to expire after 30 days because it
    // leaves your app open to attackers. At that time, all client
    // requests to your Firestore database will be denied.
    //
    // Make sure to write security rules for your app before that time, or else
    // all client requests to your Firestore database will be denied until you Update
    // your rules
    match /{document=**} {
      allow read, write: if request.time < timestamp.date(2024, 5, 25);
    	allow read, create: if request.auth != null;
    }
  }
}
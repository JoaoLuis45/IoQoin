// Regras de Segurança do Firestore para o IoQoin
// Copie e cole este conteúdo no Console do Firebase:
// https://console.firebase.google.com/project/ioqoin/firestore/rules

/*
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // Função auxiliar para verificar se o usuário está autenticado
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Função para verificar se o usuário é o dono do documento
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // Regras para coleção de usuários
    match /usuarios/{userId} {
      allow read, write: if isAuthenticated() && isOwner(userId);
    }
    
    // Regras para coleção de categorias
    match /categorias/{categoryId} {
      allow read: if isAuthenticated() && isOwner(resource.data.userId);
      allow create: if isAuthenticated() && isOwner(request.resource.data.userId);
      allow update, delete: if isAuthenticated() && isOwner(resource.data.userId);
    }
    
    // Regras para coleção de transações (receitas/despesas)
    match /transacoes/{transactionId} {
      allow read: if isAuthenticated() && isOwner(resource.data.userId);
      allow create: if isAuthenticated() && isOwner(request.resource.data.userId);
      allow update, delete: if isAuthenticated() && isOwner(resource.data.userId);
    }
    
    // Regras para coleção de objetivos
    match /objetivos/{goalId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
    
    // Regras para coleção de inscrições
    match /inscricoes/{subscriptionId} {
      allow read: if isAuthenticated() && resource.data.userId == request.auth.uid;
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if isAuthenticated() && resource.data.userId == request.auth.uid;
    }
  }
}
*/

// INSTRUÇÕES:
// 1. Acesse o Console do Firebase: https://console.firebase.google.com
// 2. Selecione o projeto "ioqoin"
// 3. Vá em Firestore Database > Regras
// 4. Substitua o conteúdo pelas regras acima (sem os comentários /* */)
// 5. Clique em "Publicar"

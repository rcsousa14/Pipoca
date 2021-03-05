let password = document.getElementById('password');
let confirmation = document.getElementById('confirmation');
let form = document.getElementById('form');
let passError = document.getElementById('passError');
const passRegex = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$/;

form.addEventListener('submit', (e)=> {
    let message = [];
    
    
    
    if(!passRegex.test(password.value)){
        console.log(passRegex.test(password))
        console.log(password)
        message.push('🔓 Mínimo de oito caracteres, pelo menos uma letra e um número!')
    }
    if( confirmation.value != password.value){
        message.push('🔓 Sua senha de confirmação precisa ser igual à senha!')
    }
    if(message.length > 0){
        e.preventDefault(); 
        passError.innerText = message.join(', ')
    }

    
    
});
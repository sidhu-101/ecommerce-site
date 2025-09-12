const url = window.location.href;
const type = new URL(url).searchParams.get('type');
if(type == "signup"){
       document.getElementById('login-element').style.display = "none" ;
       document.getElementById('signup-element').style.display = "block" ;
       document.getElementById('forget-password').style.display = "none";
}  
if(type == "forget"){
    document.getElementById('signup-element').style.display = "none" ;
    document.getElementById('login-element').style.display = "none" ;
     document.getElementById('forget-password').style.display = "block";
}
    // Remove the readonly attribute when the user focuses on the field
document.querySelectorAll('input[readonly]').forEach((input) => {
  input.addEventListener('focus', () => {
    input.removeAttribute('readonly');
  });
});
document.getElementById('forget-password-button').addEventListener("click", () => {
    const btn = document.getElementById('forget-password-button');
    
    if (btn.textContent === 'Send Otp') {
        btn.textContent = 'verify';
    }
});

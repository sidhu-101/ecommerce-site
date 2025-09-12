const h2Element = document.getElementById('my-orders-h2');
// Get the edit and save buttons
const editNameButton = document.getElementById('edit-name');
const saveNameButton = document.getElementById('save-name');
const editEmailButton = document.getElementById('edit-email');
const saveEmailButton = document.getElementById('save-email');
const editPhoneButton = document.getElementById('edit-phone');
const savePhoneButton = document.getElementById('save-phone');

const name_view = document.getElementById('name');
const email_view = document.getElementById('email');
const phone_view = document.getElementById('phoneno');

h2Element.addEventListener('click', () => {
  window.location.href = 'orders.jsp';
});

const profile_information = document.getElementById('profile_information');
profile_information.addEventListener('click', () => {
  window.location.href = './profile.jsp'
});


const manage_address = document.getElementById('manage_address');
manage_address.addEventListener('click', () => {
  window.location.href = './profile.jsp?type=manage_address'
});

const wishlist = document.getElementById('wishlist');
wishlist.addEventListener('click', () => {
  window.location.href = './profile.jsp?type=wishlist'
});

const orders = document.getElementById('orders');
orders.addEventListener('click', () => {
  window.location.href = './profile.jsp?type=orders'
});



// Add event listeners to the edit buttons
editNameButton.addEventListener('click', () => {
    if (editNameButton.textContent === 'Cancel') {
      editNameButton.textContent = 'Edit';
      saveNameButton.style.display = 'none';
      name_view.disabled = true ;
    } else {
      editNameButton.textContent = 'Cancel';
      saveNameButton.style.display = 'block';
      name_view.disabled = false ;
    }
  });

editEmailButton.addEventListener('click', () => {
    if (editEmailButton.textContent === 'Cancel') {
      editEmailButton.textContent = 'Edit';
      saveEmailButton.style.display = 'none';
      email_view.disabled = true ;
    } else {
      editEmailButton.textContent = 'Cancel';
      saveEmailButton.style.display = 'block';
      email_view.disabled = false ;
    }
  });

editPhoneButton.addEventListener('click', () => {
    if (editPhoneButton.textContent === 'Cancel') {
      editPhoneButton.textContent = 'Edit';
      savePhoneButton.style.display = 'none';
      phone_view.disabled = true ;
    } else {
      editPhoneButton.textContent = 'Cancel';
      savePhoneButton.style.display = 'block';
      phone_view.disabled = false ;
    }
  });

document.addEventListener('DOMContentLoaded', function() {
    // Get the modal
    const url = window.location.href;
    const type = new URL(url).searchParams.get('type');
    if(type == "manage_address"){
      document.getElementById('order').style.display = "none" ;
      document.getElementById('manage_add').style.display = "block" ;
      document.getElementById('profile-detail').style.display = "none" ;
      document.getElementById('fav').style.display = "none" ;
    }
    else if(type == "wishlist"){
      document.getElementById('order').style.display = "none" ;
      document.getElementById('manage_add').style.display = "none" ;
      document.getElementById('profile-detail').style.display = "none" ;
      document.getElementById('fav').style.display = "block" ;
    }
    else if(type == "orders"){
      document.getElementById('fav').style.display = "none" ;
      document.getElementById('order').style.display = "block" ;
      document.getElementById('manage_add').style.display = "none" ;
      document.getElementById('profile-detail').style.display = "none" ;
    }
    else{
      document.getElementById('fav').style.display = "none" ;
      document.getElementById('order').style.display = "none" ;
      document.getElementById('manage_add').style.display = "none" ;
      document.getElementById('profile-detail').style.display = "block" ;
    }
    
})

document.getElementById('add_address').addEventListener('click', () => {
    const add = document.getElementById('add_address_pannel');
      add.style.display = "flex";
});
document.getElementById('cancel').addEventListener('click', () => {
  const add = document.getElementById('add_address_pannel');
    add.style.display = "none";
});
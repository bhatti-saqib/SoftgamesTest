

function sendFirstAndLastName() {
    let firstName = document.getElementById("firstNameInput").value;
    let lastName = document.getElementById("lastNameInput").value;
    
    var names = { "firstName": firstName, "lastName": lastName }

    try {
        webkit.messageHandlers.sendToiOS.postMessage(names);
        
    } catch(err) {
        console.log('error');
    }
}


function updateFullName(name) {
    document.getElementById("fullName").value = name;
}



function sendDateOfBirth() {
    let dob = document.getElementById("DOB").value;
    if(dob.value === null || typeof(dob.value) === 'undefined' || dob.value === '') {
        return false
    }
    
    try {
        webkit.messageHandlers.sendToiOS.postMessage(dob);
    }
    catch(err) {
        console.log('error');
    }
}


function updateAgeField(age) {
    document.getElementById("age").value = age;
}


function trigger() {
    try {
        webkit.messageHandlers.sendToiOS.postMessage(true);
    }
    catch(err) {
        console.log('error');
    }
}

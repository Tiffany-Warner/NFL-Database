// function populateDayDropDown(){
//     var dayDropDown = document.getElementById("day"); 
    
//     for(var i = 0; i < 31; i++) {
//         var dayNum = i;
//         var element = document.createElement("option");
//         element.textContent = dayNum + 1;
//         element.value = dayNum + 1;
//         dayDropDown.appendChild(element);
//     };
// };



// function populateYearDropDown(){
//     var yearDropDown = document.getElementById("year"); 
//     var currentYear = (new Date()).getFullYear(); //Reference https://stackoverflow.com/questions/6002254/get-the-current-year-in-javascript
    
//     for(var i = 1950; i < currentYear - 17; i++) {
//         var year = i;
//         var element = document.createElement("option");
//         element.textContent = year + 1;
//         element.value = year + 1;
//         yearDropDown.appendChild(element);
//     };
// };

function populateYear_DraftedDropDown(){
    var year_draftedDropDown = document.getElementById("year_drafted"); 
    var currentYear = (new Date()).getFullYear(); //Reference https://stackoverflow.com/questions/6002254/get-the-current-year-in-javascript
    
    for(var i = 1980; i <= currentYear; i++) {
        var year = i;
        var element = document.createElement("option");
        element.textContent = year;
        element.value = year;
        year_draftedDropDown.appendChild(element);
    };
};


function initDropDowns(){
    // populateDayDropDown();
    // populateYearDropDown();
    populateYear_DraftedDropDown();
}

//Call functions
initDropDowns();
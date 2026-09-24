
//   in this code  we get user current  location  
//   then we compare current location  and location at save in database   
// if both location are correct then  discout apply in cart

import  location from  "node-geocoder";


const options  =  {

  provider : 'openstreetmap'
}

const geo  = location(options)


async function getlocation() {
 
  try{

    const res =  await geo.geocode('raiwala')


  

    return  res[0].city 
  }

  catch(ex){
console.log(ex)
  }
}

 const loc = await getlocation()


 console.log(loc)



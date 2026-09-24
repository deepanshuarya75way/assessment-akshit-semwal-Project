import userprofile from "../../models/userprofile.model.js";


import location  from  "../services/user_location.services.js"


import  calculatelocationDiscount from  "../utils/coupon.service.js"
import productModel from "../models/product.model.js";
export  const discountLocation =  async(req ,res) => {



  try {

     const userId = req.user.id;

        if (!userId) {
      return res.status(400).json({
        message: "UserId is required",
      });
    }

    // Find profile in MongoDB
    const profile = await userprofile.findOne({
      userid: userId,
    });


      if (!profile) {
      return res.status(200).json({
        success: true,
        message: "Profile not created yet",
        data: null,
      });
    }
 

  
    const useradd =  profile.address[0].address1;


    const currentadd =  await location()


    //  if  both location are  then apply discount on cart

 const product = await productModel.find().populate("category_id");
    if (!product) {
      return res.status(400).json({
        message: "Product not found",
      });
    }

    if(useradd === currentadd) {


      //  this is fuction  for calutate the discount   if both location are equal
   
       await calculatelocationDiscount(userId ,product);

    }


  }


  catch(ex) {

    console.log(ex)
  }

}
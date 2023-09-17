//
//  ResetPasswordView.swift
//  Project190
//
//  Created by Luis Campos on 9/12/23.
//

import SwiftUI
import KeychainSwift

struct ResetPasswordView: View{
    @Binding var showNextView: DisplayState
    
    @State private var displayText:String = "Please enter your new password"
    @State private var newPassword:String = ""
    @State private var confirmNewPassword:String = ""
    @State private var passCheck = false
    @State private var nextView: DisplayState = .login
    @State private var showPassword = false
    @State private var studentDiffPassword = false
    @State private var teacherDiffPassword = false
    @State private var confirmColor = Color.green
    
    /*private let log = LoginView(showNextView: $nextView)
     private let kc = log.keychain*/
    private let kc = KeychainSwift()
    
    var body: some View{
        VStack{
            
            Button(action:{}){
                Text("MAIN/PASSWORD RESET")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .frame(width:300, height:20, alignment: .center)
            }
            .padding()
            .background(Color.black)
            .cornerRadius(100)
            .padding(.bottom, 200)
            
            //Displaying the prompt for creating a new password
            Text(displayText)
                .fontWeight(.bold)
            
            /*These if else statements are supposed to help display the text field entry
             for the users new password and depending on if the user clicks on the show
             button it will display the new password or hide it if they click hide.*/
            if(showPassword == true){
                TextField("New Password: ", text:$newPassword)
                    .padding([.trailing, .leading], 50)
                    .padding(.bottom, 10)
                    .padding(.top, 50)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
            }
            else{
                SecureField("New Password: ", text:$newPassword)
                    .padding([.trailing, .leading], 50)
                    .padding(.bottom, 10)
                    .padding(.top, 50)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
            }
            /*These if else statements are supposed to help display the text field entry
             for the users to confirm their new password and depending on if the user clicks
             on the show button it will display the new password or hide it if they click hide.*/
            if(showPassword == true){
                TextField("Confirm New Password: ", text:$confirmNewPassword)
                    .padding([.trailing, .leading], 50)
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
            }
            else{
                SecureField("Confirm New Password: ", text:$confirmNewPassword)
                    .padding([.trailing, .leading], 50)
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(.roundedBorder)
            }
            /*This section is for displaying the buttons to either show or hide the new password
             that the user wants to replace their previous password*/
            HStack{
                Button(action:{
                    showPassword = true
                }){
                    Text("Show").foregroundColor(Color.black)
                }
                .padding(15)
                .background(Color.cyan)
                .border(Color.black,width: 5)
                .cornerRadius(6)
                Button(action:{
                    self.showPassword = false
                }){
                    Text("Hide").foregroundColor(Color.black)
                }
                .padding(15)
                .background(Color.gray)
                .border(Color.black,width: 5)
                .cornerRadius(6)
            }
            
            /*Finally this section of code is for the confirmation button and it checks
             to see if both of the passwords that the user types into the fields are the same*/
            Button(action:{
                let npass = newPassword
                let cNPass = confirmNewPassword
                let passCheck = npass==cNPass
                /*These variables are supposed to store whether or not if the student's new password
                 or the teacher's new password matches their previous password. If it does then it will
                 remain on the reset page until they type in a new password*/
                let studentDiffPassword = npass != kc.get("registeredStudentPassword")
                let teacherDiffPassword = npass != kc.get("registeredTeacherPassword")
                if passCheck && studentDiffPassword == true{
                    displayText="Correct New Password"
                    kc.set(npass, forKey: "registeredStudentPassword")
                    nextView = .login
                    confirmColor = Color.green
                }
                else if passCheck && teacherDiffPassword == true{
                    displayText="Correct New Password"
                    kc.set(npass, forKey: "registeredTeacherPassword")
                    nextView = .login
                    confirmColor = Color.green
                }
                else if ((passCheck == false && studentDiffPassword == false) ||
                         (passCheck == false && teacherDiffPassword == false) ||
                passCheck == false){
                    displayText="Incorrect New Password"
                    nextView = .resetPassword
                    confirmColor = Color.red
                }
                
                withAnimation{showNextView = nextView}
            }){
                Text("Confirm")
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
            }
            .padding()
            .background(confirmColor)
            .cornerRadius(100)
            .padding(.top,180)
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider{
    @State static private var showNextView: DisplayState = .resetPassword
    
    static var previews: some View{
        ResetPasswordView(showNextView: $showNextView)
    }
}

//
//  TeacherManageUsers.swift
//  Project190
//
//  Created by user123 on 4/20/23.
//

import SwiftUI





struct TeacherManageUsers: View
{
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var studentList: StudentList
    @State var studentName = ""
    @State private var activeNavigationLink: String? = nil
    
    //This function is required to provide an activeNavigationLink for every value in studentList
    //Without this, every NavigationLink will be registered as active simultaneously.
    //Credit to user jnpdx on StackOverflow for this.
    func bindingForItem(item: String) -> Binding<Bool> {
        .init {
            activeNavigationLink == item
        } set: { newValue in
            activeNavigationLink = newValue ? item : nil
        }
    }
    
    var body: some View
    {
        NavigationView{
            VStack
            {
                Button(action: {dismiss()}){
                    Text("MAIN / MANAGE USERS")
                        .fontWeight(btnStyle.getFont())
                        .foregroundColor(btnStyle.getPathFontColor())
                        .frame(width: btnStyle.getWidth(),
                               height: btnStyle.getHeight(),
                               alignment: btnStyle.getAlignment())
                       
                }
                .padding()
                .background(btnStyle.getPathColor())
                .cornerRadius(btnStyle.getPathRadius())
                .padding(.top)
                Spacer()
                
                TextField("Search for Registered Users",text: $studentName)
                    .multilineTextAlignment(.center)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth:1))
                    .frame(maxWidth:UIScreen.main.bounds.size.width*0.75)
                    .padding(.bottom, 25)
                    .padding(.top, 30)
                
                List {
                    ForEach(studentList.students, id:\.self) { student in
                        if(studentName.isEmpty || student.contains(studentName))
                        {
                            NavigationLink(
                                destination:TeacherUserRequestView(stackingPermitted: self.$activeNavigationLink, userName: student)
                                .navigationBarHidden(true),
                                isActive: bindingForItem(item: student)){
                                Text(student)
                                    .font(.callout)
                                    .foregroundColor(btnStyle.getBtnFontColor())
                            }
                                .isDetailLink(false)
                        }
                    }
                }
                .overlay(RoundedRectangle(cornerRadius:10, style:.circular)
                    .stroke(lineWidth:5))
                .frame(maxWidth: UIScreen.main.bounds.size.width*0.80,
                       maxHeight: UIScreen.main.bounds.size.height*0.75)
                .padding(.bottom, 300)
                .cornerRadius(5)
            }
        }
        .preferredColorScheme(btnStyle.getTeacherScheme() == 0 ? .light : .dark)
    }
    
    struct TeacherManageUsers_Previews: PreviewProvider {
        @StateObject var studentList = StudentList()
        static var previews: some View {
            TeacherManageUsers()
                .environmentObject(StudentList())
        }
    }
}

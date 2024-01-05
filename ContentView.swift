
import SwiftUI
import FirebaseAuth


struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("skipLogin") private var skipLogin = false

    var body: some View {
        if isLoggedIn || skipLogin {
            ContentView(isLoggedIn: $isLoggedIn, skipLogin: $skipLogin)
        } else {
            LogInListView(isLoggedIn: $isLoggedIn, skipLogin: $skipLogin)
        }
    }
}
struct ContentView: View {
    @ObservedObject var bookManager = BookManager()
    @State private var searchTerm: String = ""
    @State private var navigateToBook = false
    @State private var showPopover = false
    @Binding var isLoggedIn: Bool
    @Binding var skipLogin: Bool
    @State private var navigateToAllBooks = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .trailing) {
                ScrollView {
                    VStack(alignment: .center, spacing: 24) {
                        Text("Track.io")
                            .font(.title2)
                            .bold()
                        VStack {
                            Spacer() // Pushes the content to the center

                            HStack {
                                TextField("Search for a book", text: $searchTerm)
                                    .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)) // Reduced padding
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(5)
                                    .foregroundColor(.blue)

                                Button(action: {
                                    // Hide the keyboard
                                    UIApplication.shared.endEditing()
                                    // Trigger the search
                                    bookManager.getBookInfo(title: searchTerm)
                                    navigateToBook = true
                                }) {
                                    Image(systemName: "magnifyingglass")
                                }
                                .padding(.trailing, 10)
                            }
                            .frame(maxWidth: .infinity) // Ensures HStack takes full width
                            NavigationLink(destination: BookListView(books: bookManager.books?.items ?? []),
                                isActive: $navigateToBook) { EmptyView() }
                            Spacer() // Pushes the content to the center
                        }

                        HStack {
                            ZStack {
                                NavigationLink(destination: AllBooksView(), isActive: $navigateToAllBooks) {
                                                   EmptyView()
                                               }
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 150, height: 200)

                                Text("Diary")
                                    .padding(.bottom, 75)
                                    .bold()

                                Image(systemName: "plus.square")
                                    .font(.largeTitle)
                                    .onTapGesture {
                                        navigateToAllBooks = true
                                    }
                            }

                            .padding(.trailing,10)
                            ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(Color.blue.opacity(0.3))
                                    .frame(width: 150, height: 200)
                                Text("Wishlist")
                                    .padding(.bottom, 75)
                                    .bold()
                                Image(systemName: "plus.square")
                                    .font(.largeTitle) // Adjust the font size as needed
                            }
                            .padding(.leading, 10)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .blur(radius: showPopover ? 10 : 0) // Optional blur effect
                }
                .background(Color.background)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            withAnimation {
                                showPopover.toggle()
                            }
                        }) {
                            Image(systemName: "equal")
                        }
                    }
                }

                if showPopover {
                    PopoverContentView(isLoggedIn: $isLoggedIn, skipLogin: $skipLogin)
                        .frame(width: 350) // Adjust width of the side menu, remove explicit height
                        .transition(.move(edge: .trailing)) // Slide in from the right
                        .zIndex(1) // Ensure menu is above main content
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(20) // Add rounded corners
                        .edgesIgnoringSafeArea(.bottom) // Ensure it covers the full height of the screen
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

// Extension to hide the keyboard when the search is triggered
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct BookListView: View {
    var books: [BookItem] // Replace 'BookItem' with your actual book item type

    var body: some View {
        List(books, id: \.id) { bookItem in
            Book_Row(book: bookItem.volumeInfo) // Adjust according to your model structure
        }
    }
}

// Define the content for your popover
struct PopoverContentView: View {
    @Binding var isLoggedIn: Bool
    @Binding var skipLogin: Bool
    var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Button(action: {
                    isLoggedIn = false
                    skipLogin = false
                }) {
                    HStack {
                        Text("Log In")
                            .bold()
                            .foregroundColor(.black)
                            .padding(.trailing, 200)
                        Image(systemName: "lock.fill")
                            .foregroundColor(.black)
                    }
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                }
            
                NavigationLink(destination: FriendsListView()){
                    HStack {
                        Text("Friends")
                            .bold()
                            .padding(.trailing, 200)
                            .foregroundColor(.black)
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                    }
                    .frame(width: 300, height: 50)
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(10)
                }
                HStack {
                    Text("Diary")
                        .bold()
                        .padding(.trailing, 200)
                        .foregroundColor(.black)
                    Image(systemName: "book")
                        .foregroundColor(.black)
                }
                .frame(width: 300, height: 50)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
                HStack {
                    Text("Wishlist")
                        .bold()
                        .padding(.trailing, 200)
                        .foregroundColor(.black)
                    Image(systemName: "book")
                        .foregroundColor(.black)
                }
                .frame(width: 300, height: 50)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
            }
            .padding()
        }
    }

struct LogInListView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggingIn: Bool = false
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @Binding var isLoggedIn: Bool
    @Binding var skipLogin: Bool
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            
            // Create offset circles for a targeting effect
            Group {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .scaleEffect(1.7)
                    .offset(x: UIScreen.main.bounds.width * 0.6, y: -UIScreen.main.bounds.height * 0.2)
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .scaleEffect(1.35)
                    .offset(x: -UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.height * 0.3)
            }
            
            // Main white circle for the login fields
            Circle()
                .fill(Color.white)
                .scaleEffect(1.5)
            
            VStack {
                Spacer()
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                
                TextField("Email", text: $username)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .border(.red, width: CGFloat(wrongUsername))

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
                    .border(.red, width: CGFloat(wrongPassword))
                Button("Skip Login") {
                                skipLogin = true
                            }
                            .padding()
                Button(action: { loginUser(username: self.username, password: self.password) }) {
        

                    Text(isLoggingIn ? "Logging in..." : "Log In")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isLoggingIn ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .disabled(isLoggingIn)
                
                Spacer()
            }
        }
    }

    func loginUser(username: String, password: String) {
        isLoggingIn = true
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
        }
    }
}


struct FriendsListView:View{
    var body: some View {
        Text("Friends LIst")
    }
}

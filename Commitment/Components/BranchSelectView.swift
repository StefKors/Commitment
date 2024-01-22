//
//  BranchSelectView.swift
//  Commitment
//
//  Created by Stef Kors on 13/01/2023.
//

import SwiftUI

struct BranchSelectButtonView: View {
    @Environment(CodeRepository.self) private var repository

    var body: some View {
        HStack {
            Image("git-branch-16")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundStyle(.primary)
            VStack(alignment: .leading) {
                Text("Current Branch")
                    .foregroundStyle(.secondary)
                Text( self.repository.branch?.name.fullName ?? "--")
                    .foregroundStyle(.primary)
            }
        }
    }
}

struct BranchSelectView: View {
    @Environment(CodeRepository.self) private var repository
    @EnvironmentObject private var viewState: ViewState
    @EnvironmentObject private var shell: Shell
    var placeholder = "Select Branch"
    @State private var searchText: String = ""
    @State private var isBranchSelectOpen: Bool = false

//    var filteredRepos: [GitReference] {
//        if searchText.isEmpty {
//            return  self.repository.branches
//        } else {
//            return  self.repository.branches.filter({ branch in
//                branch.name.localName.localizedCaseInsensitiveContains(searchText)
//            })
//        }
//    }

    var sectionedBranches: [String: [GitReference]] {
        Dictionary(grouping: self.repository.branches) { branch in
            if branch.name.remoteName.isEmpty {
                return "local"
            }

            return branch.name.remoteName
        }
    }

    var body: some View {
        BranchSelectButtonView()
            .contentShape(Rectangle())
            .onTapGesture {
                isBranchSelectOpen.toggle()
            }
            .popover(isPresented: $isBranchSelectOpen, attachmentAnchor: .point(UnitPoint.bottom), arrowEdge: .bottom, content: {
                menuContent
                    .presentationDragIndicator(.visible)
            })
        //.overlay(isPresented: $viewState.isBranchSelectOpen, alignment: .topLeading, relativePos: .bottomLeading, extendHorizontally: true) {
        //  menuContent
        //}
    }

    var menuContent: some View {
        VStack(spacing: 0) {
//        List {

            ForEach(Array(sectionedBranches.keys).sorted(), id: \.self) { origin in
                if let branches = sectionedBranches[origin] {
                    GroupBox(origin) {
                        ForEach(branches) { branch in
                            Button(action: {
                                Task(priority: .userInitiated, operation: { @MainActor in
                                    let name = branch.name.fullName
                                    print("checkout branch \(name)")
                                    await shell.checkout(name)
                                    //                                try await self.repository.refreshRepoState()
                                })
                            }, label: {
                                HStack {
                                    Image("git-branch-16")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 16, height: 16)
                                        .foregroundStyle(.primary)

                                    HStack(spacing: 0) {
                                        if branch.name.remoteName.isNotEmpty {
                                            Text(branch.name.remoteName)
                                                .foregroundStyle(.secondary)

                                            Text("/")
                                        }

                                        Text(branch.name.localName)
                                            .foregroundStyle(.primary)
                                    }

                                    Spacer(minLength: 4)
                                    Text(branch.date, format: .relative(presentation: .named))
                                        .foregroundStyle(.secondary)
                                }
                                //                    .frame(height: 16)
                            })
                            .buttonStyle(.toolbarMenuButtonStyle)
                        }
                    }
                }
            }

            //            TextField("Branch Search", text: $searchText, prompt: Text("Filter"))
            //                .textFieldStyle(.roundedBorder)
            //                .font(.body)
            //                .overlay(alignment: .trailing) {
            //                    if !searchText.isEmpty {
            //                        Button(action: {
            //                            self.searchText = ""
            //                        }) {
            //                            Image(systemName: "multiply.circle.fill")
            //                                .foregroundStyle(.secondary)
            //                                .padding(.trailing, 4)
            //                        }.buttonStyle(.plain)
            //                    }
            //                }

//            ForEach(self.repository.branches) { branch in
//                Button(action: {
//                    Task(priority: .userInitiated, operation: { @MainActor in
//                        let name = branch.name.fullName
//                        print("checkout branch \(name)")
//                        await shell.checkout(name)
//                        //                                try await self.repository.refreshRepoState()
//                    })
//                }, label: {
//                    HStack {
//                        Image("git-branch-16")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 16, height: 16)
//                            .foregroundStyle(.primary)
//
//                        HStack(spacing: 0) {
//                            if branch.name.remoteName.isNotEmpty {
//                                Text(branch.name.remoteName)
//                                    .foregroundStyle(.secondary)
//
//                                Text("/")
//                            }
//
//                            Text(branch.name.localName)
//                                .foregroundStyle(.primary)
//                        }
//
//                        Spacer(minLength: 4)
//                        Text(branch.date, format: .relative(presentation: .named))
//                            .foregroundStyle(.secondary)
//                    }
////                    .frame(height: 16)
//                })
//                .buttonStyle(.toolbarMenuButtonStyle)
//
////                if branch.id == self.repository.branches.first?.id {
////                    Divider() 
////                        .padding(4)
////                }
//            }

        }
        .truncationMode(.tail)
        .frame(maxWidth: 400)
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .background(.ultraThinMaterial)
        .cornerRadius(6)
//        .overlay(RoundedRectangle(cornerRadius: 6).stroke(.separator, lineWidth: 1))
        .shadow(radius: 15)
    }

    func createBranch() {
        print("TODO: create branch")
    }
}

struct BranchSelectView_Previews: PreviewProvider {
    static var previews: some View {
        BranchSelectView()
    }
}

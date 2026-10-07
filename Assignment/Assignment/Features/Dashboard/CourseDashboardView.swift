//
//  CourseDashboardView.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import SwiftUI

struct CourseDashboardView: View {
    @Bindable var viewModel: CourseDashboardViewModel
    let dependencies: AppDependencies
    var onLogout: () -> Void

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView("Loading courses…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .empty:
                    ContentUnavailableView(
                        "No courses",
                        systemImage: "books.vertical",
                        description: Text("There are no courses to display.")
                    )
                case .failure(let message):
                    ContentUnavailableView {
                        Label("Couldn’t load courses", systemImage: "exclamationmark.triangle")
                    } description: {
                        Text(message)
                    } actions: {
                        Button("Retry") {
                            Task { await viewModel.load(forceRefresh: true) }
                        }
                    }
                case .success(let courses):
                    List(courses) { course in
                        NavigationLink {
                            CourseDetailView(
                                viewModel: CourseDetailViewModel(
                                    courseID: course.id,
                                    repository: dependencies.courseRepository
                                )
                            )
                        } label: {
                            CourseRowView(course: course)
                        }
                    }
                    .refreshable {
                        await viewModel.load(forceRefresh: true)
                    }
                }
            }
            .navigationTitle("Courses")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if viewModel.isOffline {
                        Label("Offline", systemImage: "wifi.slash")
                            .foregroundStyle(.orange)
                            .font(.caption)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout", action: onLogout)
                }
            }
            .onAppear {
                viewModel.syncOfflineFlag()
                viewModel.applyCachedIfLoaded()
            }
            .task {
                if case .idle = viewModel.state {
                    await viewModel.load()
                }
            }
        }
    }
}

struct CourseRowView: View {
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(course.title)
                .font(.headline)
            Text(course.instructor)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ProgressView(value: Double(course.progress), total: 100)
            HStack {
                Text("\(course.progress)% complete")
                Spacer()
                Text("\(course.lessonCount) lessons")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            Text("Continue")
                .font(.subheadline.weight(.semibold))
        }
        .padding(.vertical, 4)
    }
}

//
//  CourseDetailView.swift
//  Assignment
//
//  Created by Kishorkumar on 07/10/26.
//

import SwiftUI

struct CourseDetailView: View {
    @Bindable var viewModel: CourseDetailViewModel

    var body: some View {
        Group {
            if let course = viewModel.course {
                List {
                    Section {
                        Text(course.title)
                            .font(.title2.weight(.semibold))
                        Text("\(course.progress)% complete")
                            .foregroundStyle(.secondary)
                        ProgressView(value: Double(course.progress), total: 100)
                    }

                    if let errorMessage = viewModel.errorMessage {
                        Section {
                            Text(errorMessage).foregroundStyle(.red)
                        }
                    }

                    Section("Lessons") {
                        ForEach(course.lessons) { lesson in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(lesson.title)
                                    Text(lesson.status == .completed ? "Completed" : "Pending")
                                        .font(.caption)
                                        .foregroundStyle(lesson.status == .completed ? .green : .secondary)
                                }
                                Spacer()
                                Image(systemName: lesson.status == .completed ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(lesson.status == .completed ? .green : .secondary)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.markCompleted(lesson)
                            }
                            .accessibilityAddTraits(.isButton)
                        }
                    }
                }
            } else {
                ContentUnavailableView("Course not found", systemImage: "questionmark.folder")
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

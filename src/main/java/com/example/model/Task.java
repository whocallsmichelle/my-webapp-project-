package com.example.model;

/**
 * Task model representing a TODO item with id, title, and completion status.
 */
public class Task {
    private int id;
    private String title;
    private boolean completed;

    /**
     * Default no-arg constructor for Task.
     */
    public Task() {
    }

    /**
     * Constructor with all parameters.
     * 
     * @param id        The unique identifier of the task
     * @param title     The title/description of the task
     * @param completed The completion status of the task
     */
    public Task(int id, String title, boolean completed) {
        this.id = id;
        this.title = title;
        this.completed = completed;
    }

    /**
     * Gets the task ID.
     * 
     * @return the task ID
     */
    public int getId() {
        return id;
    }

    /**
     * Sets the task ID.
     * 
     * @param id the task ID to set
     */
    public void setId(int id) {
        this.id = id;
    }

    /**
     * Gets the task title.
     * 
     * @return the task title
     */
    public String getTitle() {
        return title;
    }

    /**
     * Sets the task title.
     * 
     * @param title the task title to set
     */
    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * Gets the completion status.
     * 
     * @return true if completed, false otherwise
     */
    public boolean isCompleted() {
        return completed;
    }

    /**
     * Sets the completion status.
     * 
     * @param completed the completion status to set
     */
    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    /**
     * Returns a string representation of the Task.
     * 
     * @return string representation
     */
    @Override
    public String toString() {
        return "Task{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", completed=" + completed +
                '}';
    }
}

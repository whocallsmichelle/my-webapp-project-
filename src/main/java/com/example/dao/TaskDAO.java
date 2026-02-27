package com.example.dao;

import com.example.model.Task;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for Task operations with SQLite database.
 */
public class TaskDAO {
    private static final Logger LOGGER = Logger.getLogger(TaskDAO.class.getName());
    private static final String DB_URL = "jdbc:sqlite:todo.db";

    static {
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "SQLite JDBC driver not found", e);
        }
        initializeDatabase();
    }

    /**
     * Initializes the database and creates the tasks table if it doesn't exist.
     */
    private static void initializeDatabase() {
        String createTableSQL = "CREATE TABLE IF NOT EXISTS tasks (" +
                "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "title TEXT NOT NULL, " +
                "completed INTEGER DEFAULT 0)";

        try (Connection conn = DriverManager.getConnection(DB_URL);
             Statement stmt = conn.createStatement()) {
            stmt.execute(createTableSQL);
            LOGGER.info("Database initialized successfully");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error initializing database", e);
        }
    }

    /**
     * Retrieves all tasks from the database.
     * 
     * @return List of all tasks
     */
    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT id, title, completed FROM tasks ORDER BY id";

        try (Connection conn = DriverManager.getConnection(DB_URL);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Task task = new Task(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getInt("completed") == 1
                );
                tasks.add(task);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving all tasks", e);
        }

        return tasks;
    }

    /**
     * Retrieves a single task by ID.
     * 
     * @param id The task ID
     * @return The Task object if found, null otherwise
     */
    public Task getTaskById(int id) {
        String sql = "SELECT id, title, completed FROM tasks WHERE id = ?";
        Task task = null;

        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    task = new Task(
                            rs.getInt("id"),
                            rs.getString("title"),
                            rs.getInt("completed") == 1
                    );
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving task by ID: " + id, e);
        }

        return task;
    }

    /**
     * Creates a new task in the database.
     * 
     * @param title The title of the new task
     * @return The ID of the newly created task, or -1 if creation failed
     */
    public int createTask(String title) {
        String sql = "INSERT INTO tasks (title, completed) VALUES (?, 0)";
        int generatedId = -1;

        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, title);
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                        LOGGER.info("Task created with ID: " + generatedId);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating task", e);
        }

        return generatedId;
    }

    /**
     * Updates an existing task in the database.
     * 
     * @param task The task with updated information
     * @return true if update was successful, false otherwise
     */
    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, completed = ? WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, task.getTitle());
            pstmt.setInt(2, task.isCompleted() ? 1 : 0);
            pstmt.setInt(3, task.getId());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                LOGGER.info("Task updated successfully: " + task.getId());
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating task", e);
        }

        return false;
    }

    /**
     * Deletes a task from the database.
     * 
     * @param id The ID of the task to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteTask(int id) {
        String sql = "DELETE FROM tasks WHERE id = ?";

        try (Connection conn = DriverManager.getConnection(DB_URL);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                LOGGER.info("Task deleted successfully: " + id);
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting task", e);
        }

        return false;
    }
}

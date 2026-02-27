package com.example.servlet;

import com.example.dao.TaskDAO;
import com.example.model.Task;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * REST API Servlet for handling CRUD operations on Tasks.
 * Endpoints:
 *   GET    /api/tasks      - Get all tasks
 *   GET    /api/tasks/{id} - Get task by ID
 *   POST   /api/tasks      - Create new task
 *   PUT    /api/tasks/{id} - Update task
 *   DELETE /api/tasks/{id} - Delete task
 */
@WebServlet("/api/tasks/*")
public class TasksServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(TasksServlet.class.getName());
    private final TaskDAO taskDAO = new TaskDAO();
    private final Gson gson = new Gson();

    /**
     * Handles GET requests for retrieving tasks.
     * 
     * @param request  The HTTP request
     * @param response The HTTP response
     * @throws ServletException if a servlet error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        setCorsHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // GET /api/tasks - Get all tasks
                List<Task> tasks = taskDAO.getAllTasks();
                String json = gson.toJson(tasks);
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(json);
            } else {
                // GET /api/tasks/{id} - Get task by ID
                String[] pathParts = pathInfo.split("/");
                if (pathParts.length == 2) {
                    int id = Integer.parseInt(pathParts[1]);
                    Task task = taskDAO.getTaskById(id);
                    
                    if (task != null) {
                        String json = gson.toJson(task);
                        response.setStatus(HttpServletResponse.SC_OK);
                        out.print(json);
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        out.print("{\"error\":\"Task not found\"}");
                    }
                } else {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print("{\"error\":\"Invalid request\"}");
                }
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid task ID\"}");
            LOGGER.log(Level.WARNING, "Invalid task ID format", e);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Internal server error\"}");
            LOGGER.log(Level.SEVERE, "Error processing GET request", e);
        }
    }

    /**
     * Handles POST requests for creating new tasks.
     * 
     * @param request  The HTTP request
     * @param response The HTTP response
     * @throws ServletException if a servlet error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        setCorsHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            String requestBody = readRequestBody(request);
            JsonObject jsonObject = JsonParser.parseString(requestBody).getAsJsonObject();
            
            if (!jsonObject.has("title") || jsonObject.get("title").getAsString().trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Title is required\"}");
                return;
            }

            String title = jsonObject.get("title").getAsString();
            int newTaskId = taskDAO.createTask(title);

            if (newTaskId > 0) {
                Task newTask = taskDAO.getTaskById(newTaskId);
                String json = gson.toJson(newTask);
                response.setStatus(HttpServletResponse.SC_CREATED);
                out.print(json);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\":\"Failed to create task\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid JSON format\"}");
            LOGGER.log(Level.SEVERE, "Error processing POST request", e);
        }
    }

    /**
     * Handles PUT requests for updating tasks.
     * 
     * @param request  The HTTP request
     * @param response The HTTP response
     * @throws ServletException if a servlet error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        setCorsHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Task ID required\"}");
                return;
            }

            String[] pathParts = pathInfo.split("/");
            if (pathParts.length != 2) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Invalid request\"}");
                return;
            }

            int id = Integer.parseInt(pathParts[1]);
            Task existingTask = taskDAO.getTaskById(id);

            if (existingTask == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Task not found\"}");
                return;
            }

            String requestBody = readRequestBody(request);
            JsonObject jsonObject = JsonParser.parseString(requestBody).getAsJsonObject();

            // Update task properties
            if (jsonObject.has("title")) {
                existingTask.setTitle(jsonObject.get("title").getAsString());
            }
            if (jsonObject.has("completed")) {
                existingTask.setCompleted(jsonObject.get("completed").getAsBoolean());
            }

            boolean updated = taskDAO.updateTask(existingTask);

            if (updated) {
                Task updatedTask = taskDAO.getTaskById(id);
                String json = gson.toJson(updatedTask);
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(json);
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\":\"Failed to update task\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid task ID\"}");
            LOGGER.log(Level.WARNING, "Invalid task ID format", e);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid JSON format\"}");
            LOGGER.log(Level.SEVERE, "Error processing PUT request", e);
        }
    }

    /**
     * Handles DELETE requests for removing tasks.
     * 
     * @param request  The HTTP request
     * @param response The HTTP response
     * @throws ServletException if a servlet error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        setCorsHeaders(response);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String pathInfo = request.getPathInfo();
        PrintWriter out = response.getWriter();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Task ID required\"}");
                return;
            }

            String[] pathParts = pathInfo.split("/");
            if (pathParts.length != 2) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Invalid request\"}");
                return;
            }

            int id = Integer.parseInt(pathParts[1]);
            boolean deleted = taskDAO.deleteTask(id);

            if (deleted) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\":\"Task not found\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid task ID\"}");
            LOGGER.log(Level.WARNING, "Invalid task ID format", e);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Internal server error\"}");
            LOGGER.log(Level.SEVERE, "Error processing DELETE request", e);
        }
    }

    /**
     * Handles OPTIONS requests for CORS preflight.
     * 
     * @param request  The HTTP request
     * @param response The HTTP response
     * @throws ServletException if a servlet error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doOptions(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setCorsHeaders(response);
        response.setStatus(HttpServletResponse.SC_OK);
    }

    /**
     * Sets CORS headers for cross-origin requests.
     * 
     * @param response The HTTP response
     */
    private void setCorsHeaders(HttpServletResponse response) {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");
        response.setHeader("Access-Control-Max-Age", "3600");
    }

    /**
     * Reads the request body as a string.
     * 
     * @param request The HTTP request
     * @return The request body as a string
     * @throws IOException if an I/O error occurs
     */
    private String readRequestBody(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }
}

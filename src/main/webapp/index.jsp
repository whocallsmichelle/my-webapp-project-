<%@ page isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<title>TODO List</title>
	<!-- Bootstrap Icons -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
	<!-- Google Fonts -->
	<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet" />
	<style>
		* { box-sizing: border-box; margin: 0; padding: 0; }

		body {
			font-family: 'Poppins', sans-serif;
			min-height: 100vh;
			background: linear-gradient(135deg, #667eea 0%, #764ba2 25%, #f093fb 50%, #f5576c 75%, #fda085 100%);
			background-size: 400% 400%;
			animation: gradientShift 12s ease infinite;
			padding: 2rem 1rem;
			position: relative;
			overflow-x: hidden;
		}

		@keyframes gradientShift {
			0% { background-position: 0% 50%; }
			50% { background-position: 100% 50%; }
			100% { background-position: 0% 50%; }
		}

		/* Floating decorative circles */
		body::before, body::after {
			content: '';
			position: fixed;
			border-radius: 50%;
			z-index: 0;
			pointer-events: none;
		}
		body::before {
			width: 300px; height: 300px;
			background: rgba(255, 255, 255, 0.08);
			top: -80px; right: -80px;
			animation: float1 8s ease-in-out infinite;
		}
		body::after {
			width: 200px; height: 200px;
			background: rgba(255, 255, 255, 0.06);
			bottom: -60px; left: -60px;
			animation: float2 10s ease-in-out infinite;
		}
		@keyframes float1 { 0%,100% { transform: translateY(0) rotate(0deg); } 50% { transform: translateY(30px) rotate(5deg); } }
		@keyframes float2 { 0%,100% { transform: translateY(0) rotate(0deg); } 50% { transform: translateY(-25px) rotate(-5deg); } }

		.app-container {
			max-width: 600px;
			margin: 0 auto;
			position: relative;
			z-index: 1;
		}

		/* Header */
		.app-header {
			text-align: center;
			margin-bottom: 2rem;
		}
		.app-header .logo {
			display: inline-flex;
			align-items: center;
			justify-content: center;
			width: 72px; height: 72px;
			background: rgba(255,255,255,0.2);
			backdrop-filter: blur(10px);
			border-radius: 20px;
			margin-bottom: 0.75rem;
			font-size: 2rem;
			color: #fff;
			box-shadow: 0 8px 32px rgba(0,0,0,0.1);
			border: 1px solid rgba(255,255,255,0.3);
		}
		.app-header h1 {
			font-size: 2.4rem;
			font-weight: 800;
			color: #fff;
			text-shadow: 0 2px 10px rgba(0,0,0,0.15);
			margin-bottom: 0.25rem;
		}
		.app-header p {
			color: rgba(255,255,255,0.8);
			font-size: 0.95rem;
			font-weight: 300;
		}

		/* Stats */
		.stats-bar {
			display: flex;
			gap: 0.75rem;
			margin-bottom: 1.5rem;
		}
		.stat-card {
			flex: 1;
			background: rgba(255,255,255,0.18);
			backdrop-filter: blur(12px);
			border: 1px solid rgba(255,255,255,0.3);
			border-radius: 16px;
			padding: 1rem;
			text-align: center;
			transition: transform 0.2s, box-shadow 0.2s;
		}
		.stat-card:hover {
			transform: translateY(-3px);
			box-shadow: 0 8px 25px rgba(0,0,0,0.12);
		}
		.stat-card .stat-number {
			font-size: 1.8rem;
			font-weight: 700;
			color: #fff;
		}
		.stat-card .stat-label {
			font-size: 0.7rem;
			text-transform: uppercase;
			letter-spacing: 1.5px;
			color: rgba(255,255,255,0.7);
			font-weight: 500;
		}
		.stat-card:nth-child(1) { background: rgba(102,126,234,0.35); }
		.stat-card:nth-child(2) { background: rgba(240,147,251,0.3); }
		.stat-card:nth-child(3) { background: rgba(69,182,73,0.3); }

		/* Main Card */
		.main-card {
			background: rgba(255,255,255,0.95);
			border-radius: 24px;
			padding: 1.75rem;
			box-shadow: 0 20px 60px rgba(0,0,0,0.15);
		}

		/* Add Task Form */
		.add-task-form {
			display: flex;
			gap: 0.5rem;
			margin-bottom: 1.25rem;
		}
		.add-task-form input {
			flex: 1;
			background: #f0f2f9;
			border: 2px solid transparent;
			border-radius: 14px;
			padding: 0.85rem 1.2rem;
			color: #333;
			font-family: 'Poppins', sans-serif;
			font-size: 0.95rem;
			transition: border-color 0.2s, box-shadow 0.2s, background 0.2s;
		}
		.add-task-form input::placeholder { color: #999; }
		.add-task-form input:focus {
			outline: none;
			border-color: #667eea;
			background: #fff;
			box-shadow: 0 0 0 4px rgba(102,126,234,0.15);
		}
		.btn-add {
			background: linear-gradient(135deg, #667eea, #764ba2);
			border: none;
			border-radius: 14px;
			padding: 0.85rem 1.5rem;
			color: #fff;
			font-family: 'Poppins', sans-serif;
			font-size: 0.95rem;
			font-weight: 600;
			cursor: pointer;
			transition: transform 0.15s, box-shadow 0.2s;
			display: flex;
			align-items: center;
			gap: 0.4rem;
			white-space: nowrap;
			box-shadow: 0 4px 15px rgba(102,126,234,0.4);
		}
		.btn-add:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(102,126,234,0.5); }
		.btn-add:active { transform: translateY(0); }

		/* Divider */
		.divider {
			height: 1px;
			background: linear-gradient(90deg, transparent, #ddd, transparent);
			margin-bottom: 1rem;
		}

		/* Task List */
		.task-list {
			list-style: none;
			padding: 0;
			margin: 0;
			display: flex;
			flex-direction: column;
			gap: 0.5rem;
		}

		.task-item {
			display: flex;
			align-items: center;
			gap: 0.75rem;
			background: #f8f9fc;
			border: 2px solid transparent;
			border-radius: 14px;
			padding: 0.85rem 1rem;
			transition: all 0.2s;
			animation: slideIn 0.3s ease;
		}
		.task-item:hover {
			background: #eef0f8;
			border-color: #667eea;
			transform: translateX(4px);
			box-shadow: 0 4px 12px rgba(102,126,234,0.1);
		}

		@keyframes slideIn {
			from { opacity: 0; transform: translateY(-10px); }
			to { opacity: 1; transform: translateY(0); }
		}

		/* Checkbox */
		.task-checkbox {
			width: 24px;
			height: 24px;
			border-radius: 8px;
			border: 2px solid #c0c5d8;
			background: #fff;
			cursor: pointer;
			display: flex;
			align-items: center;
			justify-content: center;
			flex-shrink: 0;
			transition: all 0.25s;
		}
		.task-checkbox:hover { border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
		.task-checkbox.checked {
			background: linear-gradient(135deg, #43e97b, #38f9d7);
			border-color: transparent;
			box-shadow: 0 3px 10px rgba(67,233,123,0.35);
		}
		.task-checkbox.checked i { display: block; }
		.task-checkbox i {
			display: none;
			font-size: 14px;
			color: #fff;
			font-weight: bold;
		}

		/* Task Title */
		.task-title {
			flex: 1;
			font-size: 0.95rem;
			font-weight: 400;
			color: #333;
			word-break: break-word;
			line-height: 1.4;
		}
		.task-item.completed .task-title {
			text-decoration: line-through;
			color: #b0b5c8;
		}
		.task-item.completed {
			opacity: 0.7;
		}

		/* Edit Input */
		.edit-input {
			flex: 1;
			background: #fff;
			border: 2px solid #667eea;
			border-radius: 10px;
			padding: 0.4rem 0.7rem;
			color: #333;
			font-family: 'Poppins', sans-serif;
			font-size: 0.95rem;
			outline: none;
			box-shadow: 0 0 0 4px rgba(102,126,234,0.12);
		}

		/* Action Buttons */
		.task-actions {
			display: flex;
			gap: 0.25rem;
			flex-shrink: 0;
		}
		.btn-icon {
			background: transparent;
			border: none;
			border-radius: 10px;
			padding: 0.4rem;
			cursor: pointer;
			color: #999;
			font-size: 1.05rem;
			transition: all 0.2s;
			display: flex;
			align-items: center;
			justify-content: center;
			width: 34px;
			height: 34px;
		}
		.btn-icon.edit:hover { color: #667eea; background: rgba(102,126,234,0.1); }
		.btn-icon.delete:hover { color: #f5576c; background: rgba(245,87,108,0.1); }
		.btn-icon.save:hover { color: #43e97b; background: rgba(67,233,123,0.1); }
		.btn-icon.cancel:hover { color: #f5576c; background: rgba(245,87,108,0.1); }

		/* Empty State */
		.empty-state {
			text-align: center;
			padding: 2.5rem 1rem;
			color: #999;
		}
		.empty-state i {
			font-size: 3.5rem;
			margin-bottom: 0.75rem;
			display: block;
			background: linear-gradient(135deg, #667eea, #f093fb);
			-webkit-background-clip: text;
			-webkit-text-fill-color: transparent;
			background-clip: text;
		}
		.empty-state p { font-size: 1rem; font-weight: 400; color: #888; }

		/* Loading */
		.loading {
			text-align: center;
			padding: 2rem;
			color: #999;
		}

		/* Toast Notification */
		.toast-container {
			position: fixed;
			bottom: 1.5rem;
			right: 1.5rem;
			z-index: 9999;
			display: flex;
			flex-direction: column;
			gap: 0.5rem;
		}
		.toast {
			background: rgba(255,255,255,0.95);
			backdrop-filter: blur(10px);
			border-radius: 12px;
			padding: 0.8rem 1.3rem;
			color: #333;
			font-size: 0.85rem;
			font-weight: 500;
			box-shadow: 0 8px 30px rgba(0,0,0,0.12);
			animation: toastIn 0.3s ease, toastOut 0.3s ease 2.5s forwards;
			display: flex;
			align-items: center;
			gap: 0.5rem;
		}
		.toast.success { border-left: 4px solid #43e97b; }
		.toast.success i { color: #43e97b; }
		.toast.error { border-left: 4px solid #f5576c; }
		.toast.error i { color: #f5576c; }

		@keyframes toastIn { from { opacity: 0; transform: translateX(30px); } to { opacity: 1; transform: translateX(0); } }
		@keyframes toastOut { from { opacity: 1; } to { opacity: 0; transform: translateY(10px); } }

		/* Responsive */
		@media (max-width: 480px) {
			body { padding: 1rem 0.5rem; }
			.app-header h1 { font-size: 1.8rem; }
			.stats-bar { gap: 0.5rem; }
			.stat-card { padding: 0.6rem; }
			.main-card { padding: 1.25rem; border-radius: 18px; }
			.add-task-form { flex-direction: column; }
			.btn-add { justify-content: center; }
		}
	</style>
</head>
<body>
	<div class="app-container">
		<!-- Header -->
		<header class="app-header">
			<div class="logo"><i class="bi bi-check2-all"></i></div>
			<h1>TODO List</h1>
			<p>Stay organized, get things done</p>
		</header>

		<!-- Stats -->
		<div class="stats-bar">
			<div class="stat-card">
				<div class="stat-number" id="totalCount">0</div>
				<div class="stat-label">Total</div>
			</div>
			<div class="stat-card">
				<div class="stat-number" id="activeCount">0</div>
				<div class="stat-label">Active</div>
			</div>
			<div class="stat-card">
				<div class="stat-number" id="completedCount">0</div>
				<div class="stat-label">Done</div>
			</div>
		</div>

		<!-- Main Card -->
		<div class="main-card">
			<!-- Add Task -->
			<form class="add-task-form" id="addTaskForm">
				<input type="text" id="taskInput" placeholder="What needs to be done?" autocomplete="off" required />
				<button type="submit" class="btn-add">
					<i class="bi bi-plus-lg"></i> Add
				</button>
			</form>

			<div class="divider"></div>

			<!-- Task List -->
			<ul class="task-list" id="taskList">
				<li class="loading"><i class="bi bi-arrow-repeat"></i> Loading tasks...</li>
			</ul>
		</div>
	</div>

	<!-- Toast Container -->
	<div class="toast-container" id="toastContainer"></div>

	<script>
		const API_URL = 'api/tasks';
		let tasks = [];

		// ---- API Functions ----

		async function fetchTasks() {
			try {
				const res = await fetch(API_URL);
				if (!res.ok) throw new Error('Failed to fetch tasks');
				tasks = await res.json();
				renderTasks();
			} catch (err) {
				showToast('Failed to load tasks', 'error');
				document.getElementById('taskList').innerHTML =
					'<li class="empty-state"><i class="bi bi-exclamation-triangle"></i><p>Could not load tasks</p></li>';
			}
		}

		async function createTask(title) {
			try {
				const res = await fetch(API_URL, {
					method: 'POST',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({ title })
				});
				if (!res.ok) throw new Error('Failed to create task');
				const task = await res.json();
				tasks.push(task);
				renderTasks();
				showToast('Task added!', 'success');
			} catch (err) {
				showToast('Failed to add task', 'error');
			}
		}

		async function updateTask(id, title, completed) {
			try {
				const res = await fetch(API_URL + '/' + id, {
					method: 'PUT',
					headers: { 'Content-Type': 'application/json' },
					body: JSON.stringify({ title, completed })
				});
				if (!res.ok) throw new Error('Failed to update task');
				const updated = await res.json();
				const idx = tasks.findIndex(t => t.id === id);
				if (idx !== -1) tasks[idx] = updated;
				renderTasks();
				showToast('Task updated!', 'success');
			} catch (err) {
				showToast('Failed to update task', 'error');
			}
		}

		async function deleteTask(id) {
			try {
				const res = await fetch(API_URL + '/' + id, { method: 'DELETE' });
				if (!res.ok && res.status !== 204) throw new Error('Failed to delete task');
				tasks = tasks.filter(t => t.id !== id);
				renderTasks();
				showToast('Task deleted!', 'success');
			} catch (err) {
				showToast('Failed to delete task', 'error');
			}
		}

		// ---- Rendering ----

		function renderTasks() {
			const list = document.getElementById('taskList');
			updateStats();

			if (tasks.length === 0) {
				list.innerHTML = '<li class="empty-state"><i class="bi bi-inbox"></i><p>No tasks yet. Add one above!</p></li>';
				return;
			}

			list.innerHTML = tasks.map(task => `
				<li class="task-item ${task.completed ? 'completed' : ''}" data-id="${task.id}">
					<div class="task-checkbox ${task.completed ? 'checked' : ''}"
						 onclick="toggleComplete(${task.id})"
						 title="${task.completed ? 'Mark as active' : 'Mark as done'}">
						<i class="bi bi-check-lg"></i>
					</div>
					<span class="task-title">${escapeHtml(task.title)}</span>
					<div class="task-actions">
						<button class="btn-icon edit" onclick="startEdit(${task.id})" title="Edit task">
							<i class="bi bi-pencil"></i>
						</button>
						<button class="btn-icon delete" onclick="deleteTask(${task.id})" title="Delete task">
							<i class="bi bi-trash3"></i>
						</button>
					</div>
				</li>
			`).join('');
		}

		function updateStats() {
			const total = tasks.length;
			const completed = tasks.filter(t => t.completed).length;
			const active = total - completed;
			document.getElementById('totalCount').textContent = total;
			document.getElementById('activeCount').textContent = active;
			document.getElementById('completedCount').textContent = completed;
		}

		// ---- Actions ----

		function toggleComplete(id) {
			const task = tasks.find(t => t.id === id);
			if (task) updateTask(id, task.title, !task.completed);
		}

		function startEdit(id) {
			const task = tasks.find(t => t.id === id);
			if (!task) return;

			const li = document.querySelector(`.task-item[data-id="${id}"]`);
			const titleSpan = li.querySelector('.task-title');
			const actionsDiv = li.querySelector('.task-actions');

			const input = document.createElement('input');
			input.type = 'text';
			input.className = 'edit-input';
			input.value = task.title;

			titleSpan.replaceWith(input);
			input.focus();
			input.select();

			actionsDiv.innerHTML = `
				<button class="btn-icon save" onclick="saveEdit(${id})" title="Save">
					<i class="bi bi-check-lg"></i>
				</button>
				<button class="btn-icon cancel" onclick="renderTasks()" title="Cancel">
					<i class="bi bi-x-lg"></i>
				</button>
			`;

			input.addEventListener('keydown', function(e) {
				if (e.key === 'Enter') saveEdit(id);
				if (e.key === 'Escape') renderTasks();
			});
		}

		function saveEdit(id) {
			const li = document.querySelector(`.task-item[data-id="${id}"]`);
			const input = li.querySelector('.edit-input');
			const newTitle = input.value.trim();
			const task = tasks.find(t => t.id === id);

			if (!newTitle) {
				showToast('Title cannot be empty', 'error');
				input.focus();
				return;
			}
			if (task) updateTask(id, newTitle, task.completed);
		}

		// ---- Utilities ----

		function escapeHtml(text) {
			const div = document.createElement('div');
			div.textContent = text;
			return div.innerHTML;
		}

		function showToast(message, type) {
			const container = document.getElementById('toastContainer');
			const toast = document.createElement('div');
			toast.className = 'toast ' + type;
			const icon = type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill';
			toast.innerHTML = '<i class="bi ' + icon + '"></i> ' + message;
			container.appendChild(toast);
			setTimeout(() => toast.remove(), 3000);
		}

		// ---- Init ----

		document.getElementById('addTaskForm').addEventListener('submit', function(e) {
			e.preventDefault();
			const input = document.getElementById('taskInput');
			const title = input.value.trim();
			if (title) {
				createTask(title);
				input.value = '';
				input.focus();
			}
		});

		// Load tasks on page load
		fetchTasks();
	</script>
</body>
</html>

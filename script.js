const STORAGE_KEY = "orHasharonSoundChecklist";

const checkboxes = document.querySelectorAll("#checklist input[type='checkbox']");
const progressBar = document.getElementById("progressBar");
const status = document.getElementById("status");
const resetBtn = document.getElementById("resetBtn");

function loadState() {
  const saved = JSON.parse(localStorage.getItem(STORAGE_KEY) || "{}");
  checkboxes.forEach((cb) => {
    cb.checked = !!saved[cb.dataset.id];
  });
  updateProgress();
}

function saveState() {
  const state = {};
  checkboxes.forEach((cb) => {
    state[cb.dataset.id] = cb.checked;
  });
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
}

function updateProgress() {
  const total = checkboxes.length;
  const checked = Array.from(checkboxes).filter((cb) => cb.checked).length;
  const percent = total ? Math.round((checked / total) * 100) : 0;
  progressBar.style.width = percent + "%";
  status.textContent = checked === total
    ? "All set! Ready to go."
    : `${checked} of ${total} items ready`;
}

checkboxes.forEach((cb) => {
  cb.addEventListener("change", () => {
    saveState();
    updateProgress();
  });
});

resetBtn.addEventListener("click", () => {
  checkboxes.forEach((cb) => (cb.checked = false));
  saveState();
  updateProgress();
});

loadState();

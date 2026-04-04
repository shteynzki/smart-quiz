<template>
  <div class="chat-widget" :class="{ 'is-open': isOpen }">
    <!-- Кнопка открытия -->
    <button class="chat-toggle" @click="isOpen = !isOpen">
      <span v-if="!isOpen">🤖 Помощник</span>
      <span v-else>✖</span>
    </button>

    <!-- Окно чата -->
    <div v-if="isOpen" class="chat-window">
      <div class="chat-header">ИИ-Дизайнер</div>

      <div class="chat-messages" ref="scrollBox">
        <div
          v-for="(msg, idx) in chatStore.messages"
          :key="idx"
          :class="['message', msg.role]"
        >
          {{ msg.content }}
        </div>
        <div v-if="chatStore.isLoading" class="message assistant typing">
          Печатает...
        </div>
      </div>

      <!-- Быстрые подсказки -->
      <div class="chat-hints" v-if="currentHints.length > 0">
        <button
          v-for="hint in currentHints"
          :key="hint"
          @click="chatStore.sendMessage(hint)"
          class="hint-btn"
        >
          {{ hint }}
        </button>
      </div>

      <div class="chat-input">
        <input
          v-model="userInput"
          @keyup.enter="handleSend"
          placeholder="Спросите что-нибудь..."
        />
        <button @click="handleSend" :disabled="chatStore.isLoading">▲</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick } from "vue";
import { useChatStore } from "@/stores/useChatStore";
import { useQuizStore } from "@/stores/useQuizStore";

const chatStore = useChatStore();
const quizStore = useQuizStore();
const isOpen = ref(false);
const userInput = ref("");
const scrollBox = ref<HTMLElement | null>(null);

const hintsMap: Record<number, string[]> = {
  1: ["Что выбрать для студии?", "Зачем указывать тип помещения?"],
  2: ["Нужна ли детская на вырост?", "Какие зоны сейчас в тренде?"],
  4: ["Расскажи про Лофт", "Минимализм или Скандинавия?"],
  5: ["Как сэкономить на ремонте?", "Что входит в этот бюджет?"],
};

const currentHints = computed(() => hintsMap[quizStore.currentStep] || []);

const handleSend = () => {
  if (!userInput.value.trim()) return;
  chatStore.sendMessage(userInput.value);
  userInput.value = "";
};

watch(
  () => chatStore.messages.length,
  async () => {
    await nextTick();
    if (scrollBox.value) {
      scrollBox.value.scrollTop = scrollBox.value.scrollHeight;
    }
  },
);
</script>

<style scoped>
.chat-widget {
  position: fixed;
  bottom: 20px;
  right: 20px;
  z-index: 1000;
  font-family: sans-serif;
}
.chat-window {
  width: 300px;
  height: 400px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 5px 25px rgba(0, 0, 0, 0.2);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}
.chat-header {
  background: #333;
  color: white;
  padding: 10px;
  font-weight: bold;
}
.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 10px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.message {
  padding: 8px 12px;
  border-radius: 8px;
  max-width: 80%;
  font-size: 14px;
}
.user {
  align-self: flex-end;
  background: #e3f2fd;
}
.assistant {
  align-self: flex-start;
  background: #f5f5f5;
}
.chat-input {
  display: flex;
  padding: 10px;
  border-top: 1px solid #eee;
}
.chat-input input {
  flex: 1;
  border: none;
  outline: none;
}
.chat-hints {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
  padding: 5px 10px;
  background: #fafafa;
}
.hint-btn {
  font-size: 11px;
  background: white;
  border: 1px solid #ddd;
  border-radius: 10px;
  cursor: pointer;
  padding: 2px 8px;
}
.chat-toggle {
  padding: 10px 20px;
  border-radius: 20px;
  border: none;
  background: #333;
  color: white;
  cursor: pointer;
}
</style>

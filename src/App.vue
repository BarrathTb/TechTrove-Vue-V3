<template>
  <div id="app">
    <router-view :session="session" />
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '@/utils/Supabase'

const session = ref(null)

onMounted(() => {
  // Listen for authentication state changes
  supabase.auth.onAuthStateChange((_event, newSession) => {
    session.value = newSession
  })
})
</script>

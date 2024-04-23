<template>
  <div class="profile-header">
    <div class="tabs">
      <button
        v-for="tab in tabs"
        :key="tab.name"
        class="tab"
        :class="{ active: activeTab === tab.name }"
        @click="activeTab = tab.name"
      >
        {{ tab.label }}
      </button>
    </div>
    <div class="avatar-container">
      <img class="avatar" src="./images/avatar.png" alt="User's avatar" />
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProfileHeader',
  data() {
    return {
      tabs: [
        { name: 'details', label: 'User Details' },
        { name: 'orders', label: 'Personal Orders' },
        { name: 'achievements', label: 'Achievements' }
      ],
      activeTab: 'orders'
    }
  }
}
</script>

<style scoped>
.profile-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
  background-color: #fff;
}

.tabs {
  display: flex;
}

.tab {
  margin-right: 8px;
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  background-color: #f0f0f0;
  cursor: pointer;
}

.tab.active {
  color: #fff;
  background-color: #007bff;
}

.avatar-container {
  padding-left: 16px;
}

.avatar {
  width: 50px; /* Adjust size as needed */
  height: 50px; /* Adjust size as needed */
  border-radius: 50%; /* Makes the image round */
}
</style>

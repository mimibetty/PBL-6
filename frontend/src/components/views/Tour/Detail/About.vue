<template>
    <div class="frame">
        <h3>About</h3>
        <div class="frame-description">
            <p class="text-break">
                {{ description }}
            </p>
        </div>
    </div>
</template>

<script>
export default {
    name: "About",
    props: {
        description: {
            type: String,
            default: ""
        }
    }
}
</script>

<style scoped>
.frame {
    margin-top: 20px;
    padding: 20px;
    border-radius: 20px;
    box-shadow: 0px 5px 30px rgba(19, 53, 123, 0.2);
    display: flex;
    flex-direction: column;
    gap: 20px;
}

h3 {
    font-weight: 900;
}

.read-more-or-less {
    color: #13357B;
    background: none;
    border: none;
    margin-left: -0.5%;
    font-size: 18px;
    font-weight: 700;
    appearance: none;
    text-decoration: underline;
    transition: all 0.3s ease-in-out;
}

.read-more-or-less:hover {
    color: #729AE9;
}
</style>
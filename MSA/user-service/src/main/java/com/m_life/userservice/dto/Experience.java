package com.m_life.userservice.dto;

public enum Experience {
    ZERO_YEAR("0년"),
    ONE_TO_TWO_YEARS("1~2년 이하"),
    THREE_TO_FIVE_YEARS("3~5년"),
    MORE_THAN_SIX_YEARS("6년 이상");

    private final String description;

    Experience(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
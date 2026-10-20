<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class QuizQuestionResource extends JsonResource
{
    public function __construct($resource, private bool $showAnswers = false)
    {
        parent::__construct($resource);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'prompt' => $this->prompt,
            'points' => $this->points,
            'position' => $this->position,
            'options' => $this->options->map(fn ($option) => [
                'id' => $option->id,
                'label' => $option->label,
                'position' => $option->position,
                ...($this->showAnswers ? ['is_correct' => $option->is_correct] : []),
            ])->values(),
        ];
    }
}

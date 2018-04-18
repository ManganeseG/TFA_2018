using UnityEngine;
using UnityEngine.SceneManagement;

public class GameOverManager : MonoBehaviour
{

    public HealthBar playerHealth;
    public float restartDelay = 5.0f;

    Animator anim;
    float restartTimer;

    private void Awake()
    {
        anim = GetComponent<Animator>();
    }

    private void Update()
    {
        if (playerHealth.Hp <= 0)
        {
            anim.SetTrigger("GameOver");
            restartTimer += Time.deltaTime;
            if (restartTimer >= restartDelay)
            {
                SceneManager.LoadScene("healthbar");
            }
        }
    }
}
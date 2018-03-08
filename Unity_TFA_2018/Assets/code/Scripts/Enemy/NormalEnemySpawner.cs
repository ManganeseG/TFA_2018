using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NormalEnemySpawner : MonoBehaviour
{
    public enum SpawnType
    {
        PointOneByOne,
        CircleOneByOne,
        CircleSimultaneous
    }

    public enum SpawnTrigger
    {
        Time,
        Distance
    }

    public enum SpawnState
    {
        Waiting,
        Spawning,
        Managing,
        AllDead
    }

    public SpawnType TypeOfSpawn = SpawnType.CircleSimultaneous;
    public float DelayBetweenSpawn = 0.5f;
    private float timeBeforeNextSpawn = 0.0f;
    public SpawnTrigger Trigger = SpawnTrigger.Time;
    public float TriggerValue = 3.0f;
    private float triggerValue;
    private SpawnState state = SpawnState.Waiting;

    public int EnemiesCount = 12;
    private int enemiesSpawned = 0;
    public NormalEnemy RefToSpawn;
    public GameObject RefToNextSpawner;
    private List<NormalEnemy> enemies = new List<NormalEnemy>();

    public float SeparationTrigger = 1.5f;
    public float CohesionTrigger = 15.0f;
    public float AlignmentTrigger = 15.0f;
    public float ChasingTrigger = 30.0f;

    public float SeparationIntensity = 1.5f;
    public float CohesionIntensity = 1.0f;
    public float AlignmentIntensity = 0.2f;
    public float ChasingIntensity = 0.5f;
    public float RandomIntensity = 0.1f;


    private static NormalEnemySpawner current;
    public static NormalEnemySpawner Current
    {
        get { return current; }
    }

    void Awake()
    {
        current = this;
    }


    void Start()
    {
        triggerValue = TriggerValue;
    }
    

    private void spawnNextEnemy()
    {
        Vector3 position = Vector3.zero;

        float relativeIndex = (float)enemiesSpawned / (float)EnemiesCount;
        enemiesSpawned++;

        switch (TypeOfSpawn)
        {
            case SpawnType.PointOneByOne:
                position = transform.position;
                break;
            case SpawnType.CircleOneByOne:
            case SpawnType.CircleSimultaneous:
                {
                    float spawnRadius = (EnemiesCount * 2.0f * RefToSpawn.Radius) /
                                        (2.0f * Mathf.PI);
                    position = transform.position + Vector3.right * spawnRadius * Mathf.Cos(relativeIndex * 2.0f * Mathf.PI) +
                        Vector3.forward * spawnRadius * Mathf.Sin(relativeIndex * 2.0f * Mathf.PI);
                }
                break;
            default:
                break;
        }
        NormalEnemy spawned = GameObject.Instantiate(RefToSpawn, position, Quaternion.identity);
        spawned.Spawner = this;
        enemies.Add(spawned);

    }

    public void Destroy(NormalEnemy deadEnemy)
    {
        enemies.Remove(deadEnemy);
        Destroy(deadEnemy.gameObject);
    }

    void Update()
    {
        switch (state)
        {
            case SpawnState.Waiting:
                {
                    switch (Trigger)
                    {
                        case SpawnTrigger.Time:
                            triggerValue -= Time.deltaTime;
                            if (triggerValue <= 0.0f)
                                state = SpawnState.Spawning;
                            break;
                        case SpawnTrigger.Distance:
                            if (Vector3.Distance(transform.position,
                               Player.Current.transform.position) <= TriggerValue)
                                state = SpawnState.Spawning;
                            break;
                        default:
                            break;
                    }
                }
                break;
            case SpawnState.Spawning:
                switch (TypeOfSpawn)
                {
                    case SpawnType.PointOneByOne:
                    case SpawnType.CircleOneByOne:
                        if (timeBeforeNextSpawn <= 0.0f)
                        {
                            spawnNextEnemy();
                            timeBeforeNextSpawn = DelayBetweenSpawn;
                        }
                        timeBeforeNextSpawn -= Time.deltaTime;
                        if (enemiesSpawned >= EnemiesCount)
                            state = SpawnState.Managing;
                        break;
                    case SpawnType.CircleSimultaneous:
                        for (int i = 0; i < EnemiesCount; i++)
                            spawnNextEnemy();
                        state = SpawnState.Managing;
                        break;
                    default:
                        break;
                }
                manageFlock();
                break;
            case SpawnState.Managing:
                {
                    manageFlock();
                    if (enemies.Count <= 0)
                        state = SpawnState.AllDead;

                }
                break;
            case SpawnState.AllDead:
                {
                    if(RefToNextSpawner != null)
                        RefToNextSpawner.SetActive(true);
                }
                break;
            default:
                break;
        }
    }

    private void manageFlock()
    {
        foreach (NormalEnemy enemy in enemies)
        {
            Vector3 separation = Vector3.zero;
            Vector3 cohesion = Vector3.zero;
            Vector3 chasing = Vector3.zero;
            Vector3 alignment = Vector3.zero;
            float cohesionCount = 0f;
            float alignmentCount = 0f;

            foreach (NormalEnemy otherEnemy in enemies)
            {
                if (otherEnemy == enemy)
                    continue;

                Vector3 delta = enemy.transform.position - otherEnemy.transform.position;
                float distance = delta.magnitude;
                delta.Normalize();

                // Separation
                if (distance < SeparationTrigger)
                    separation += (delta / distance) * (1.0f - distance / SeparationTrigger);

                // Cohesion
                if (distance < CohesionTrigger)
                {
                    cohesionCount++;
                    cohesion += otherEnemy.transform.position;
                }

                if (distance < AlignmentTrigger)
                {
                    alignmentCount++;
                    alignment += otherEnemy.Speed;
                }
            }

            if (cohesionCount > 0f)
            {
                cohesion /= cohesionCount;
                cohesion -= enemy.transform.position;
            }

            if (alignmentCount > 0f)
            {
                alignment /= alignmentCount;
            }

            Vector3 deltaPlayer = Player.Current.transform.position - enemy.transform.position;

            if (deltaPlayer.magnitude < ChasingTrigger)
            {
                chasing += deltaPlayer.normalized;
            }

            enemy.AddForce(separation * SeparationIntensity +
                            cohesion * CohesionIntensity +
                            alignment * AlignmentIntensity +
                            chasing * ChasingIntensity +
                            enemy.RandomDirection * RandomIntensity);
        }
    }
}
